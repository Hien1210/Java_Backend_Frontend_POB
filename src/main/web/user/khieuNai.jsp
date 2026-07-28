<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khiếu nại đơn hàng - POB</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-theme.css">
    <style>
        :root {
            --bg:      #FFFBF8;
            --surface: #FFFFFF;
            --surface-lt: #FFF4EC;
            --gold:    #FF5A1F;
            --text:    #241C15;
            --muted:   #8A7B6C;
            --border:  #F1E4D6;
            --font-b:  'Plus Jakarta Sans', sans-serif;
            --tr: all .25s ease;
        }
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: var(--font-b); background: var(--bg); color: var(--text); min-height: 100vh; }
        a { text-decoration: none; color: inherit; transition: var(--tr); }

        /* NAVBAR */
        .navbar {
            background: rgba(255,251,248,.92); backdrop-filter: blur(14px);
            border-bottom: 1px solid var(--border);
            height: 74px; display: flex; align-items: center;
            padding: 0 30px; position: sticky; top: 0; z-index: 100; gap: 16px;
        }
        .nav-logo { font-size: 1.55rem; font-weight: 800; letter-spacing: -.5px; }
        .nav-logo span { color: var(--gold); }
        .nav-title { font-size: .95rem; font-weight: 700; color: var(--text); }
        .nav-sep { width: 1px; height: 20px; background: var(--border); }
        .nav-right { margin-left: auto; display: flex; gap: 10px; }
        .nav-link {
            display: inline-flex; align-items: center; gap: 7px; position: relative;
            padding: 9px 18px; font-size: .85rem; font-weight: 700;
            color: var(--muted); border: 1.5px solid var(--border); border-radius: 50px;
        }
        .nav-link:hover { color: var(--gold); border-color: var(--gold); background: var(--surface-lt); }

        .container { max-width: 760px; margin: 0 auto; padding: 40px 20px 80px; }

        .alert { display: flex; align-items: center; gap: 10px; padding: 14px 18px; margin-bottom: 20px; border-radius: 14px; border: 1px solid; font-size: .9rem; font-weight: 600; }
        .alert-success { background: #EAFBF1; border-color: #BBF0CF; color: #15803D; }
        .alert-danger  { background: #FEECEF; border-color: #FBD0D8; color: #E11D48; }

        .card { background: var(--surface); border: 1px solid var(--border); border-radius: 18px; box-shadow: 0 4px 18px rgba(60,30,10,.06); padding: 22px; margin-bottom: 20px; }
        .card h3 { margin-top: 0; font-size: 16px; color: var(--text); }
        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 13px; font-weight: 700; color: var(--text); margin-bottom: 6px; }
        .form-group input, .form-group textarea { width: 100%; padding: 11px 14px; border-radius: 10px; border: 1.5px solid var(--border); background: var(--surface-lt); color: var(--text); font-size: 13.5px; font-family: var(--font-b); }
        .form-group input:focus, .form-group textarea:focus { outline: none; border-color: var(--gold); background: var(--surface); }
        .form-group textarea { min-height: 110px; resize: vertical; }
        .btn-submit { padding: 11px 24px; border-radius: 50px; border: none; background: linear-gradient(135deg, var(--gold), #E14A0F); color: #fff; font-weight: 700; font-size: 13.5px; cursor: pointer; box-shadow: 0 8px 22px rgba(255,90,31,.32); }
        .btn-submit:hover { filter: brightness(1.05); }

        .complaint-item { padding: 16px; border: 1px solid var(--border); border-radius: 14px; margin-bottom: 12px; background: var(--surface-lt); }
        .complaint-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; flex-wrap: wrap; gap: 6px; }
        .complaint-subject { font-weight: 700; color: var(--text); }
        .complaint-content { font-size: 13px; color: var(--muted); margin-bottom: 8px; white-space: pre-wrap; }
        .complaint-reply { font-size: 13px; background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 10px 12px; color: var(--text); }

        .badge { display: inline-flex; align-items: center; gap: 4px; font-size: 11px; font-weight: 700; padding: 3px 10px; border-radius: 50px; white-space: nowrap; }
        .badge-pending { background: #FEF3C7; color: #B45309; }
        .badge-processing { background: #DBEAFE; color: #1D4ED8; }
        .badge-resolved { background: #DCFCE7; color: #15803D; }
        .badge-rejected { background: #FEE2E2; color: #DC2626; }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-logo"><span>POB</span></div>
    <div class="nav-sep"></div>
    <span class="nav-title">Khiếu nại đơn hàng</span>
    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/user/donhang" class="nav-link">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/user/diem-thuong" class="nav-link">🎁 Điểm thưởng</a>
        <a href="${pageContext.request.contextPath}/user/thong-bao" class="nav-link">🔔 Thông báo<span data-notif-badge style="display:${unreadNotifCount > 0 ? 'inline-block' : 'none'};margin-left:2px;background:#E11D48;color:#fff;border-radius:999px;font-size:10px;min-width:16px;height:16px;line-height:16px;text-align:center;padding:0 3px;font-weight:700;">${unreadNotifCount}</span></a>
        <a href="${pageContext.request.contextPath}/user/home" class="nav-link">← Trang chủ</a>
    </div>
</div>

<div class="container">

    <c:if test="${param.success eq '1'}">
        <div class="alert alert-success">✅ Đã gửi khiếu nại! Admin sẽ xem xét và phản hồi sớm nhất.</div>
    </c:if>
    <c:if test="${param.error eq 'empty'}">
        <div class="alert alert-danger">❌ Vui lòng nhập đủ tiêu đề và nội dung khiếu nại.</div>
    </c:if>
    <c:if test="${param.error eq 'not_found'}">
        <div class="alert alert-danger">❌ Không tìm thấy đơn hàng hoặc đơn không thuộc về bạn.</div>
    </c:if>
    <c:if test="${param.error eq 'fail'}">
        <div class="alert alert-danger">❌ Gửi khiếu nại thất bại, vui lòng thử lại.</div>
    </c:if>

    <c:if test="${not empty order}">
        <div class="card">
            <h3>📝 Gửi khiếu nại cho đơn #${order.id}</h3>
            <form method="post" action="${pageContext.request.contextPath}/khieu-nai">
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
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
        <h3>📋 Khiếu nại của tôi</h3>
        <c:choose>
            <c:when test="${empty complaints}">
                <p style="color:var(--muted);font-size:13.5px;">Bạn chưa gửi khiếu nại nào. Vào <a href="${pageContext.request.contextPath}/user/donhang" style="color:var(--gold);font-weight:700;">Đơn hàng của tôi</a> để chọn đơn cần khiếu nại.</p>
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
