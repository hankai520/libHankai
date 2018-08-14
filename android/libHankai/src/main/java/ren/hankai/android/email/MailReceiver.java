package ren.hankai.android.email;

import com.sun.mail.util.MailSSLSocketFactory;

import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.activation.CommandMap;
import javax.activation.MailcapCommandMap;
import javax.mail.BodyPart;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.NoSuchProviderException;
import javax.mail.Part;
import javax.mail.Session;
import javax.mail.Store;

public class MailReceiver {
    private Store store;
    private Map<String, Folder> folders = new HashMap<>();

    /**
     * 加载邮箱文件夹。
     */
    private void reloadFolders() {
        if (null != this.store && this.store.isConnected()) {
            try {
                Folder[] list = store.getDefaultFolder().list();
                for (Folder folder: list) {
                    folders.put(folder.getName(), folder);
                }
            } catch (MessagingException ex) {
                System.out.println("Failed to load folders.");
                ex.printStackTrace();
            }
        }
    }

    /**
     * 获取指定邮箱文件夹。
     * @param folderName 文件夹名称
     * @return 文件夹
     */
    private Folder getFolder(String folderName) {
        Folder folder = folders.get(folderName);
        if (null != folder && !folder.isOpen()) {
            try {
                folder.open(Folder.READ_WRITE);
            } catch (MessagingException e) {
                System.out.print(String.format("Failed to open folder \"%s\"", folderName));
                e.printStackTrace();
            }
        }
        return folder;
    }

    /**
     * 构造邮件接收器。
     * @param host 服务器IP或域名
     * @param port 端口
     * @param sslEnabled 是否启用SSL
     */
    public MailReceiver(String host, String port, boolean sslEnabled) {
        this(host, port, sslEnabled, new String[0]);
    }

    /**
     * 构造邮件接收器。
     * @param host 服务器IP或域名
     * @param port 端口
     * @param sslEnabled 是否启用SSL
     * @param trustedHosts 信任的服务器IP或域名
     */
    public MailReceiver(String host, String port, boolean sslEnabled, String[] trustedHosts) {
        Properties props = new Properties();
        props.setProperty("mail.store.protocol", "imap");
        props.setProperty("mail.imap.host", host);

        if (sslEnabled) {
            try {
                MailSSLSocketFactory socketFactory = new MailSSLSocketFactory();
                if (null == trustedHosts) {
                    socketFactory.setTrustAllHosts(true);
                } else {
                    socketFactory.setTrustedHosts(trustedHosts);
                }
                props.put("mail.imap.ssl.socketFactory", socketFactory);
            } catch (GeneralSecurityException e) {
                e.printStackTrace();
            }
            props.setProperty("mail.imap.socketFactory.fallback", "false");
            props.setProperty("mail.imap.starttls.enable", "true");
            props.setProperty("mail.imap.socketFactory.port", port);
        } else {
            props.setProperty("mail.imap.port", port);
        }

        Session session = Session.getInstance(props);
        try {
            this.store = session.getStore("imap");
        } catch (NoSuchProviderException ex) {
            throw new IllegalArgumentException("Illegal protocal was set.", ex);
        }

        // There is something wrong with MailCap, javamail can not find a handler for the multipart/mixed part,
        // so this bit needs to be added.
        MailcapCommandMap mc = (MailcapCommandMap) CommandMap.getDefaultCommandMap();
        mc.addMailcap("text/html;; x-java-content-handler=com.sun.mail.handlers.text_html");
        mc.addMailcap("text/xml;; x-java-content-handler=com.sun.mail.handlers.text_xml");
        mc.addMailcap("text/plain;; x-java-content-handler=com.sun.mail.handlers.text_plain");
        mc.addMailcap("multipart/*;; x-java-content-handler=com.sun.mail.handlers.multipart_mixed");
        mc.addMailcap("message/rfc822;; x-java-content-handler=com.sun.mail.handlers.message_rfc822");
        CommandMap.setDefaultCommandMap(mc);

        System.setProperty("mail.mime.decodetext.strict", "false");
    }

    /**
     * 连接服务器。
     * @param userName 用户名
     * @param password 密码
     * @return 当前邮件接收器实例
     */
    public MailReceiver connect(String userName, String password) {
        if (null != this.store && !this.store.isConnected()) {
            try {
                this.store.connect(userName, password);
                reloadFolders();
            } catch (MessagingException ex) {
                throw new RuntimeException("Failed to connect to mail server", ex);
            }
        }
        return this;
    }

    /**
     * 断开与服务器的连接。
     */
    public void disconnect() {
        if (null != this.store && this.store.isConnected()) {
            try {
                this.store.close();
                folders.clear();
            } catch (MessagingException ex) {
                throw new RuntimeException("Failed to disconnect to mail server", ex);
            }
        }
    }

    /**
     * 获取邮箱中的文件夹名称列表。
     * @return 名称列表
     */
    public List<String> getFolderNames() {
        List<String> names = new ArrayList<>(folders.keySet());
        return names;
    }

    /**
     * 查询未读邮件数。
     * @param folderName 文件夹名称
     * @return 未读邮件数
     */
    public int getMessageCount(String folderName, MessageCountType type) {
        Folder folder = getFolder(folderName);
        try {
            if (MessageCountType.NewMessages == type) {
                return folder.getNewMessageCount();
            } else if (MessageCountType.NewMessages == type) {
                return folder.getUnreadMessageCount();
            } else if (MessageCountType.AllMessages == type) {
                return folder.getMessageCount();
            } else if (MessageCountType.DeletedMessages == type) {
                return folder.getDeletedMessageCount();
            }
        } catch (MessagingException ex) {
            System.out.println(String.format("Failed to get folder \"%s\"", folderName));
        }
        return 0;
    }

    /**
     * 查询邮件。
     * @param folderName 文件夹名称
     * @param page 分页索引（从 1 开始）
     * @param size 分页大小（10<=size<=50）
     * @return
     */
    public MailList getMessages(String folderName, int page, int size) {
        MailList list = new MailList();
        try {
            Folder folder = getFolder(folderName);
            size = (size<10 || size>50) ? 10 : size;
            int maxCount = folder.getMessageCount();
            size = size > maxCount ? maxCount : size;
            int start = size*(page-1)+1;
            int end = start + size - 1;
            Message[] msgs = folder.getMessages(start, end);
            for (Message msg : msgs) {
                list.getMessages().add(msg);
            }
            list.setPage(page);
            list.setSize(size);
            //已加载数 = 上一页加载数 + 本页加载数
            int loadedCount = (page-1) * size + list.getMessages().size();
            list.setHasMore(loadedCount < maxCount);
            list.setTotal(maxCount);
        } catch (MessagingException ex) {
            System.out.println(String.format("Failed to get folder \"%s\"", folderName));
        }
        return list;
    }

    /**
     * 在指定文件夹中查询指定邮件。
     * @param folderName 文件夹名称
     * @param messageNumber 邮件编号
     * @return 邮件
     */
    public Message getMessage(String folderName, int messageNumber) {
        try {
            Folder folder = getFolder(folderName);
            return folder.getMessage(messageNumber);
        } catch (MessagingException ex) {
            System.out.println(String.format(
                    "Failed to get message with number \"%d\" in folder \"%s\".", messageNumber, folderName));
        }
        return null;
    }

    /**
     * 获取邮件中的附件。
     * @param message 邮件
     * @return 附件列表
     */
    public List<MailAttachment> getAttachmentsOfMessage(Part message) {
        List<MailAttachment> attachments = new ArrayList<>();
        try {
            Object content = message.getContent();
            if (content instanceof Multipart) {
                Multipart mContent = (Multipart)content;
                int parts = mContent.getCount();
                for (int i=0; i<parts; i++) {
                    BodyPart bodyPart = mContent.getBodyPart(i);
                    if (bodyPart.getContent() instanceof Multipart) {
                        attachments.addAll(getAttachmentsOfMessage(bodyPart));
                    } else if (Part.ATTACHMENT.equalsIgnoreCase(bodyPart.getDisposition()) ||
                            Part.INLINE.equalsIgnoreCase(bodyPart.getDisposition()) ||
                            (null != bodyPart.getFileName() && !"".equals(bodyPart.getFileName().trim()))) {
                        attachments.add(new MailAttachment(bodyPart));
                    }

                }
            } else if (message.isMimeType("message/rfc822")) {
                attachments.addAll(getAttachmentsOfMessage((Part)message.getContent()));
            }
        } catch (MessagingException ex) {
            ex.printStackTrace();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        return attachments;
    }

}
