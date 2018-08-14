package ren.hankai.android;

import ren.hankai.android.email.MailAttachment;
import ren.hankai.android.email.MailList;
import ren.hankai.android.email.MailReceiver;
import ren.hankai.android.email.MessageCountType;

import android.content.res.AssetManager;
import android.support.test.runner.AndroidJUnit4;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.util.List;

import javax.mail.Message;

/**
 * Instrumented test, which will execute on an Android device.
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
@RunWith(AndroidJUnit4.class)
public class MailReceiverTest {

    private MailReceiver receiver = null;

    @Before
    public void prepare() {
        //coremail
        String host = "192.168.1.153";
        String port = "993";
        receiver = new MailReceiver(host, port, true, new String[]{host});
        receiver.connect("admin@jsxw.cn", "admin");
    }


    @Test
    public void testGetFolderNames() throws Exception {
        List<String> names = receiver.getFolderNames();
        Assert.assertTrue(null != names && names.size()>0);
    }

    @Test
    public void testGetMessageCount() throws Exception {
        int unread = receiver.getMessageCount("INBOX", MessageCountType.UnreadMessages);
        Assert.assertTrue(unread > 0);
    }

    @Test
    public void testGetMessages() throws Exception {
        MailList list = receiver.getMessages("INBOX", 1, 10);
        Assert.assertTrue(list.getTotal() > 0);
    }

    @Test
    public void testGetAttachmentsOfMessage() throws Exception {
        Message msg = receiver.getMessage("INBOX",5);
        List<MailAttachment> attachments = receiver.getAttachmentsOfMessage(msg);
        if (attachments.size() > 0) {
            for (MailAttachment ma : attachments) {
                Assert.assertNotNull(ma.getName());
                Assert.assertTrue(ma.getSizeInBytes() > 0);
                Assert.assertFalse(ma.isInline());
            }
        }
    }

}
