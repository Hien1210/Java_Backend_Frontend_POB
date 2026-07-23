package org.example.models;

import java.time.LocalDateTime;

public class Feedback {
    private long id;
    private long orderId;
    private String reviewerType;   // USER | SHIPPER
    private long reviewerId;
    private String reviewerName;   // tên hiển thị (có thể là "Ẩn danh")
    private String targetType;     // SHOP | SHIPPER
    private long targetId;
    private int rating;            // 1-5
    private String comment;
    private boolean anonymous;
    private LocalDateTime createdAt;
    private String status;         // VISIBLE | PENDING_REVIEW | REMOVED
    private String targetName;         // ten Shop/Shipper bi binh luan (khong luu DB, chi de hien thi)
    private String highlightedComment; // comment da escape HTML + wrap <mark class="bad-word"> quanh tu cam (khong luu DB)
    private LocalDateTime reviewedAt;  // thoi diem Super Admin phe duyet/xoa bo (null neu chua qua kiem duyet)

    public Feedback() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getOrderId() { return orderId; }
    public void setOrderId(long orderId) { this.orderId = orderId; }

    public String getReviewerType() { return reviewerType; }
    public void setReviewerType(String reviewerType) { this.reviewerType = reviewerType; }

    public long getReviewerId() { return reviewerId; }
    public void setReviewerId(long reviewerId) { this.reviewerId = reviewerId; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }

    public String getTargetType() { return targetType; }
    public void setTargetType(String targetType) { this.targetType = targetType; }

    public long getTargetId() { return targetId; }
    public void setTargetId(long targetId) { this.targetId = targetId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public boolean isAnonymous() { return anonymous; }
    public void setAnonymous(boolean anonymous) { this.anonymous = anonymous; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getTargetName() { return targetName; }
    public void setTargetName(String targetName) { this.targetName = targetName; }

    public String getHighlightedComment() { return highlightedComment; }
    public void setHighlightedComment(String highlightedComment) { this.highlightedComment = highlightedComment; }

    public LocalDateTime getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(LocalDateTime reviewedAt) { this.reviewedAt = reviewedAt; }
}
