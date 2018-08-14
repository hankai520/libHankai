package ren.hankai.android.email;

import java.util.ArrayList;
import java.util.List;

import javax.mail.Message;

/**
 * 邮件列表包装类。
 * Created by hankai on 2018/8/14.
 */

public class MailList {

    private List<Message> messages = new ArrayList<>();

    private boolean hasMore;

    private int total;

    private int page;

    private int size;

    public List<Message> getMessages() {
        return messages;
    }

    public void setMessages(List<Message> messages) {
        this.messages = messages;
    }

    public boolean isHasMore() {
        return hasMore;
    }

    public void setHasMore(boolean hasMore) {
        this.hasMore = hasMore;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

}
