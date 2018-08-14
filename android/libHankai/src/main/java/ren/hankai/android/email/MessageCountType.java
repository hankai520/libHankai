package ren.hankai.android.email;

/**
 * 邮箱邮件数类型（如：新邮件、未读邮件）。
 *
 * Created by hankai on 2018/8/14.
 */

public enum MessageCountType {
    /**
     * 新邮件数。
     */
    NewMessages,
    /**
     * 未读邮件数。
     */
    UnreadMessages,
    /**
     * 所有邮件数。
     */
    AllMessages,
    /**
     * 已删除的邮件数。
     */
    DeletedMessages
}
