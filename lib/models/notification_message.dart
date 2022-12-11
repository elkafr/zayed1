class NotificationMsg {
    NotificationMsg({
        this.messageId,
        this.messageTitle,
        this.messageContent,
        this.messageAdsId,
        this.messageView,
        this.messageIsViewed,
        this.messageSender,
        this.messageDate,
        this.delete,
    });

    String messageId;
    String messageTitle;
    String messageContent;
    String messageAdsId;
    int messageView;
    String messageIsViewed;
    String messageSender;
    String messageDate;
    String delete;

    factory NotificationMsg.fromJson(Map<String, dynamic> json) => NotificationMsg(
        messageId: json["message_id"],
        messageTitle: json["message_title"],
        messageContent: json["message_content"],
        messageAdsId: json["message_ads_id"],
        messageView: json["message_view"],
        messageIsViewed: json["message_is_viewed"],
        messageSender: json["message_sender"],
        messageDate: json["message_date"],
        delete: json["delete"],
    );

    Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "message_title": messageTitle,
        "message_content": messageContent,
        "message_ads_id": messageAdsId,
        "message_view": messageView,
        "message_is_viewed": messageIsViewed,
        "message_sender": messageSender,
        "message_date": messageDate,
        "delete": delete,
    };
}
