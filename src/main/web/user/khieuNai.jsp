<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khiếu nại đơn hàng - POB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme-space.css">
    <style>
        .mini-nav { background: var(--bg-panel-solid); border-bottom: 1px solid var(--border-color); padding: 16px 24px; display: flex; align-items: center; gap: 16px; }
        .mini-nav .logo { width: 36px; height: 36px; border-radius: var(--radius-sm); background: linear-gradient(135deg, var(--primary), var(--secondary)); color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; box-shadow: var(--glow-primary); }
        .mini-nav .title { font-size: 17px; font-weight: 800; color: var(--text-main); }
        .mini-nav .nav-links { margin-left: auto; display: flex; align-items: center; gap: 18px; }
        .mini-nav .nav-links a { font-size: 13px; color: var(--text-muted); }
        .mini-nav .nav-links a:hover { color: var(--secondary); }

        .container { max-width: 760px; margin: 0 auto; padding: 32px 16px; }
        .card { padding: 20px; margin-bottom: 20px; }
        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 13px; font-weight: 700; color: var(--text-main); margin-bottom: 6px; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px 12px; border-radius: var(--radius-sm); border: 1.5px solid var(--border-color); background: var(--bg-input); color: var(--text-main); font-size: 13.5px; }
        .form-group textarea { min-height: 110px; resize: vertical; }
        .btn-submit { padding: 10px 22px; border-radius: var(--radius-pill); border: none; background: var(--primary); color: #fff; font-weight: 700; font-size: 13.5px; cursor: pointer; }

        .complaint-item { padding: 16px; border: 1px solid var(--border-color); border-radius: var(--radius-sm); margin-bottom: 12px; }
        .complaint-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; flex-wrap: wrap; gap: 6px; }
        .complaint-subject { font-weight: 700; color: var(--text-main); }
        .complaint-content { font-size: 13px; color: var(--text-dim); margin-bottom: 8px; white-space: pre-wrap; }
        .complaint-reply { font-size: 13px; background: rgba(255,255,255,.04); border-radius: var(--radius-sm); padding: 10px 12px; color: var(--text-main); }
        .badge-pending { background: var(--warning-light); color: var(--warning); }
        .badge-processing { background: var(--info-light); color: var(--info); }
        .badge-resolved { background: var(--success-light); color: var(--success); }
        .badge-rejected { background: var(--danger-light); color: var(--danger); }
    </style>
</head>
<body class="space-scope">
<div class="starfield"></div>

<div class="mini-nav">
    <div class="logo">POB</div>
    <span class="title">Khiếu nại đơn hàng</span>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/user/donhang">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/thong-bao">🔔 Thông báo</a>
        <a href="${pageContext.request.contextPath}/user/home">← Trang chủ</a>
    </div>
</div>

<div class="container">

    <c:if test="${param.success eq '1'}">
        <div class="alert alert-success" style="margin-bottom:20px;">✅ Đã gửi khiếu nại! Admin sẽ xem xét và phản hồi sớm nhất.</div>
    </c:if>
    <c:if test="${param.error eq 'empty'}">
        <div class="alert alert-danger" style="margin-bottom:20px;">❌ Vui lòng nhập đủ tiêu đề và nội dung khiếu nại.</div>
    </c:if>
    <c:if test="${param.error eq 'not_found'}">
        <div class="alert alert-danger" style="margin-bottom:20px;">❌ Không tìm thấy đơn hàng hoặc đơn không thuộc về bạn.</div>
    </c:if>
    <c:if test="${param.error eq 'fail'}">
        <div class="alert alert-danger" style="margin-bottom:20px;">❌ Gửi khiếu nại thất bại, vui lòng thử lại.</div>
    </c:if>

    <c:if test="${not empty order}">
        <div class="card">
            <h3 style="margin-top:0;">📝 Gửi khiếu nại cho đơn #${order.id}</h3>
            <form method="post" action="${pageContext.request.contextPath}/khieu-nai">
                <input type="hidden" name="orderId" value="${order.id}"/>
                <div class="form-group">
                    <label>Tiêu đề</label>
                    <input type="text" name="subject" maxlength="255" placeholder="VD: Giao thiếu món, món không đúng mô tả..." required/>
                </div>
                <div class="form-group">
                    <label>Nội dung chi tiết</label>
                    <textarea name="content" placeholder="Mô tả cụ thể vấn đề bạn gặp phải với đơn hàng này..." required></textarea>
                </div>
                <button type="submit" class="btn-submit">Gửi khiếu nại</button>
            </form>
        </div>
    </c:if>

    <div class="card">
        <h3 style="margin-top:0;">📋 Khiếu nại của tôi</h3>
        <c:choose>
            <c:when test="${empty complaints}">
                <p style="color:var(--text-dim);font-size:13.5px;">Bạn chưa gửi khiếu nại nào. Vào <a href="${pageContext.request.contextPath}/user/donhang">Đơn hàng của tôi</a> để chọn đơn cần khiếu nại.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="c" items="${complaints}">
                    <div class="complaint-item">
                        <div class="complaint-top">
                            <span class="complaint-subject">#${c.orderId} — <c:out value="${c.subject}"/></span>
                            <span class="badge
                                ${c.status == 'PENDING' ? 'badge-pending' :
                                  c.status == 'PROCESSING' ? 'badge-processing' :
                                  c.status == 'RESOLVED' ? 'badge-resolved' : 'badge-rejected'}">
                                <c:choose>
                                    <c:when test="${c.status eq 'PENDING'}">⏳ Chờ xử lý</c:when>
                                    <c:when test="${c.status eq 'PROCESSING'}">🔄 Đang xử lý</c:when>
                                    <c:when test="${c.status eq 'RESOLVED'}">✅ Đã giải quyết</c:when>
                                    <c:otherwise>❌ Từ chối</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="complaint-content"><c:out value="${c.content}"/></div>
                        <c:if test="${not empty c.adminReply}">
                            <div class="complaint-reply">💬 <strong>Phản hồi từ Admin:</strong> <c:out value="${c.adminReply}"/></div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</div>
<script>window.POB_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/notifications-ws.js"></script>
</body>
</html>
