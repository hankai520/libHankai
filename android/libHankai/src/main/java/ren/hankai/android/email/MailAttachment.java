package ren.hankai.android.email;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;

import javax.mail.BodyPart;
import javax.mail.MessagingException;
import javax.mail.Part;
import javax.mail.internet.MimeUtility;

/**
 * 邮件附件。
 *
 * Created by hankai on 2018/8/14.
 */

public class MailAttachment {

    private String name; //附件文件名
    private BodyPart part; //附件主体部分
    private int size; //字节
    private boolean inline; //是否是内嵌的图片（例如：html正文中嵌入图片）

    public MailAttachment(BodyPart part) {
        this.part = part;
        try {
            name = MimeUtility.decodeText(part.getFileName());
            size = part.getSize();
            if (Part.INLINE.equalsIgnoreCase(part.getDisposition())) {
                inline = true;
            }
        } catch (MessagingException ex) {
            ex.printStackTrace();
        } catch (UnsupportedEncodingException ex) {
            ex.printStackTrace();
        }
    }


    public String getName() {
        return name;
    }

    public int getSizeInBytes() {
        return size;
    }

    public boolean isInline() {
        return inline;
    }

    /**
     * 保存附件到指定目录。
     * @param outputStream 输出流
     * @return 是否保存成功
     */
    public boolean save(OutputStream outputStream) {
        BufferedInputStream inBuff = null;
        try {
            inBuff = new BufferedInputStream(part.getInputStream());
            byte[] buffer = new byte[1024 * 5];
            int len;
            while ((len = inBuff.read(buffer)) != -1) {
                outputStream.write(buffer,0, len);
            }
            outputStream.flush();
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        } finally {
            try {
                if (inBuff != null) {
                    inBuff.close();
                }
                if (outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return true;
    }
}
