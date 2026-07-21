package org.example.daos;

import org.example.models.Feedback;

import java.util.List;

public interface FeedbackDAO {

    /** Lưu feedback mới */
    boolean save(Feedback feedback);

    /** Kiểm tra order này đã được reviewer_type feedback target_type chưa */
    boolean existsByOrderAndType(long orderId, String reviewerType, String targetType);

    /**
     * Kiểm tra reviewer có quyền feedback không:
     * - USER → SHOP  : order phải DELIVERED, userId == reviewer_id, shopId == target_id
     * - USER → SHIPPER: order phải DELIVERED, userId == reviewer_id, shipperId == target_id
     * - SHIPPER → SHOP: order phải DELIVERED, shipperId == reviewer_id, shopId == target_id
     */
    boolean canFeedback(long orderId, String reviewerType, long reviewerId, String targetType, long targetId);

    /** Lấy danh sách feedback theo target (shop hoặc shipper), lọc theo reviewer_type */
    List<Feedback> findByTarget(String targetType, long targetId, String reviewerType);

    /** Rating trung bình của target */
    double avgRating(String targetType, long targetId);

    /** Tổng số feedback của target */
    int countByTarget(String targetType, long targetId);

    /** Tăng bom_count của user, trả về giá trị mới */
    int incrementBomCount(long accountId);

    /** Lấy bom_count hiện tại */
    int getBomCount(long accountId);

    /** Tổng số feedback có rating &lt;= threshold (toàn hệ thống, cả SHOP lẫn SHIPPER) */
    int countLowRatingFeedback(int threshold);

    /**
     * Quét chuỗi bình luận qua danh sách từ cấm lưu trong bảng BannedWords (DB).
     * Trả về true nếu bình luận chứa ít nhất 1 từ cấm (không phân biệt hoa/thường).
     * Dùng để tự động gắn trạng thái PENDING_REVIEW khi lưu feedback (xem save()).
     */
    boolean checkBadWords(String comment);

    /** Danh sách bình luận đang ở trạng thái PENDING_REVIEW (chờ Super Admin duyệt) */
    List<Feedback> findPendingReview();

    /** Super Admin duyệt (VISIBLE) hoặc xóa bỏ (REMOVED) 1 bình luận đang chờ duyệt */
    boolean updateStatus(long feedbackId, String status);
}
