<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>!function(){var t=localStorage.getItem("pob-dashboard-theme")||"light";document.documentElement.setAttribute("data-theme",t)}()</script>
    <title>Quản lý Voucher - Super Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        :root[data-theme="dark"] {
            --bg-base: #0f172a; --bg-sidebar: #1e293b; --bg-panel: #1e293b; --bg-input: #0f172a;
            --bg-hover: #1e293b; --text-main: #f8fafc; --text-muted: #94a3b8; --text-dim: #64748b;
            --border-color: #334155; --topbar-bg: rgba(30, 41, 59, 0.8);
        }
        .avatar-wrapper { position: relative; }
        .avatar-dropdown { display: none; position: fixed; background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; box-shadow: var(--dash-shadow-md); min-width: 220px; z-index: 500; }
        .avatar-dropdown.open { display: block; }
        .dropdown-header { padding: 14px 16px; border-bottom: 1px solid var(--border-color); }
        .dropdown-header .d-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
        .dropdown-header .d-email { font-size: 12px; color: var(--text-muted); margin-top: 2px; }
        .dropdown-body { padding: 6px 0 8px; }
        .dropdown-link { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 13px; color: var(--text-muted); cursor: pointer; }
        .dropdown-link:hover { background: var(--bg-input); color: var(--text-main); }
        .dropdown-divider { height: 1px; background: var(--border-color); margin: 4px 0; }
        .dropdown-link.danger { color: var(--danger); }

        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .form-full { grid-column: 1 / -1; }
        .voucher-code-pill { font-family: monospace; font-weight: 700; background: var(--bg-input); padding: 3px 8px; border-radius: 6px; border: 1px dashed var(--border-color); }
    </style>
</head>
<body class="dash-body">
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="logo-mark-dash">
            <c:choose>
                <c:when test="${not empty sessionScope.account.logoUrl}">
                    <img src="${sessionScope.account.logoUrl}" alt="logo" class="logo-mark-img"/>
                </c:when>
                <c:otherwise>S</c:otherwise>
            </c:choose>
        </div>
        <div class="brand-text">
            <span class="brand-title">SUPER ADMIN</span>
            <span class="brand-subtitle">👋 ${sessionScope.account.userName}</span>
        </div>
    <button type="button" class="sidebar-toggle-btn" id="sidebarToggleBtn" onclick="pobToggleSidebar()" title="Thu gọn / mở rộng menu">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
    </button>
    </div>
    <div class="menu">
        <div class="menu-title">📊 Tổng quan &amp; phân tích</div>
        <a href="${pageContext.request.contextPath}/tong-quan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">⊞</span><span class="mi-label"> Tổng quan hệ thống</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/bao-cao-van-hanh" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📈</span><span class="mi-label"> Báo cáo vận hành</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/heatmap-don-hang" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🗺️</span><span class="mi-label"> Heatmap đặt hàng</span></span>
        </a>

        <div class="menu-title">⚖️ Kiểm duyệt &amp; điều phối</div>
        <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🏪</span><span class="mi-label"> Duyệt Shop</span></span>
            <c:if test="${shopChoDuyet > 0}"><span class="menu-badge yellow">${shopChoDuyet}</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/super-admin/shipper-requests" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🛵</span><span class="mi-label"> Duyệt Shipper</span></span>
            <c:if test="${not empty pendingShippers}"><span class="menu-badge yellow">${pendingShippers.size()}</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-noi-dung" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🚩</span><span class="mi-label"> Kiểm duyệt nội dung</span></span>
            <c:if test="${not empty pendingProducts}"><span class="menu-badge yellow">${pendingProducts.size()}</span></c:if>
        </a>
        <a href="${pageContext.request.contextPath}/admin/kiem-duyet-binh-luan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">💬</span><span class="mi-label"> Kiểm duyệt bình luận</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/khieu-nai" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📢</span><span class="mi-label"> Quản lý khiếu nại</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/appeals" class="menu-item">
            <span class="mi-left"><span class="mi-icon">📋</span><span class="mi-label"> Kháng nghị</span></span>
            <c:if test="${pendingCount > 0}"><span class="menu-badge yellow">${pendingCount}</span></c:if>
        </a>

        <div class="menu-title">💰 Quản lý tài chính</div>
        <a href="${pageContext.request.contextPath}/admin/doi-soat-doanh-thu-shop" class="menu-item">
            <span class="mi-left"><span class="mi-icon">💵</span><span class="mi-label"> Đối soát doanh thu Shop</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/duyet-rut-tien-shipper" class="menu-item">
            <span class="mi-left"><span class="mi-icon">💳</span><span class="mi-label"> Duyệt rút tiền Shipper</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/vouchers" class="menu-item active">
            <span class="mi-left"><span class="mi-icon">🎟️</span><span class="mi-label"> Voucher / Khuyến mãi</span></span>
        </a>

        <div class="menu-title">⚙️ Cấu hình &amp; hệ thống</div>
        <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item">
            <span class="mi-left"><span class="mi-icon">👤</span><span class="mi-label"> Người dùng</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/tham-so-van-hanh" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🛠️</span><span class="mi-label"> Tham số vận hành</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/faq" class="menu-item">
            <span class="mi-left"><span class="mi-icon">❓</span><span class="mi-label"> FAQ / Hướng dẫn</span></span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/audit-logs" class="menu-item">
            <span class="mi-left"><span class="mi-icon">🕒</span><span class="mi-label"> Nhật ký hệ thống</span></span>
        </a>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:10px;">
            <button type="button" class="menu-toggle-btn" onclick="pobToggleSidebar()">☰</button>
            <h1>QUẢN LÝ VOUCHER / KHUYẾN MÃI</h1>
        </div>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" onclick="pobToggleTheme()" title="Chuyển đổi giao diện"><span data-theme-icon>🌙</span></button>
            <div class="avatar-wrapper" id="avatarWrapper">
                <div class="avatar-circle" id="avatarBtn">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.avatarUrl}">
                            <img src="${sessionScope.account.avatarUrl}" alt="avatar"/>
                        </c:when>
                        <c:otherwise>${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <div class="content">
        <c:if test="${param.success eq 'create'}"><div class="alert alert-success">✅ Đã tạo voucher!</div></c:if>
        <c:if test="${param.success eq 'update'}"><div class="alert alert-success">✅ Đã cập nhật voucher!</div></c:if>
        <c:if test="${param.success eq 'toggle'}"><div class="alert alert-success">✅ Đã đổi trạng thái voucher!</div></c:if>
        <c:if test="${param.success eq 'delete'}"><div class="alert alert-success">✅ Đã xoá voucher!</div></c:if>
        <c:if test="${not empty loi}"><div class="alert alert-danger">⚠️ <c:out value="${loi}"/></div></c:if>

        <div class="toolbar">
            <div style="font-size:13px;color:var(--text-muted);">Tổng số: <strong>${vouchers.size()}</strong> voucher</div>
            <button type="button" class="btn btn-primary" onclick="openCreateModal()">+ Tạo voucher mới</button>
        </div>

        <div class="panel">
            <div class="panel-body" style="padding:0;">
                <div class="dash-table-wrap">
                    <table class="dash-table">
                        <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Loại</th>
                            <th>Giá trị</th>
                            <th>Đơn tối thiểu</th>
                            <th>Lượt dùng</th>
                            <th>Hiệu lực</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="v" items="${vouchers}">
                            <tr>
                                <td><span class="voucher-code-pill">${v.code}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.voucherType == 'PERCENT'}">Giảm %</c:when>
                                        <c:when test="${v.voucherType == 'FIXED'}">Giảm cố định</c:when>
                                        <c:otherwise>Miễn phí ship</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.voucherType == 'PERCENT'}">
                                            ${v.value}%<c:if test="${not empty v.maxDiscount}"> (tối đa <fmt:formatNumber value="${v.maxDiscount}" type="number"/>đ)</c:if>
                                        </c:when>
                                        <c:when test="${v.voucherType == 'FIXED'}">
                                            <fmt:formatNumber value="${v.value}" type="number"/>đ
                                        </c:when>
                                        <c:otherwise>Toàn bộ phí ship</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatNumber value="${v.minOrderValue}" type="number"/>đ</td>
                                <td>${v.usedCount}<c:if test="${not empty v.usageLimit}"> / ${v.usageLimit}</c:if></td>
                                <td style="font-size:11.5px;color:var(--text-dim);">
                                    <c:if test="${not empty v.startDate}">Từ ${v.startDate}<br></c:if>
                                    <c:if test="${not empty v.endDate}">Đến ${v.endDate}</c:if>
                                    <c:if test="${empty v.startDate && empty v.endDate}">Không giới hạn</c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.active}"><span class="badge badge-success">Đang bật</span></c:when>
                                        <c:otherwise><span class="badge badge-neutral">Đã tắt</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="white-space:nowrap;">
                                    <button type="button" class="btn btn-sm btn-ghost" onclick='openEditModal(${v.id}, "${v.code}", "${v.voucherType}", ${v.value}, ${v.minOrderValue}, ${not empty v.maxDiscount ? v.maxDiscount : "null"}, ${not empty v.usageLimit ? v.usageLimit : "null"}, "${not empty v.startDate ? v.startDate : ""}", "${not empty v.endDate ? v.endDate : ""}")'>✏️ Sửa</button>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" style="display:inline;">
                                        <input type="hidden" name="action" value="toggle">
                                        <input type="hidden" name="id" value="${v.id}">
                                        <button type="submit" class="btn btn-sm btn-warning">${v.active ? '⏸ Tắt' : '▶ Bật'}</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" style="display:inline;" onsubmit="return confirm('Xoá voucher này? Không thể hoàn tác.');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${v.id}">
                                        <button type="submit" class="btn btn-sm btn-danger">🗑 Xoá</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty vouchers}">
                            <tr><td colspan="8" class="empty-state">Chưa có voucher nào.</td></tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<div class="avatar-dropdown" id="avatarDropdown">
    <div class="dropdown-header">
        <div class="d-name">${sessionScope.account.userName}</div>
        <div class="d-email">${sessionScope.account.email}</div>
        <span class="d-role">Super Admin</span>
    </div>
    <div class="dropdown-body">
        <a href="${pageContext.request.contextPath}/admin/profile" class="dropdown-link">👤 Hồ sơ cá nhân</a>
        <a href="${pageContext.request.contextPath}/admin/change-password" class="dropdown-link">🔒 Đổi mật khẩu</a>
        <div class="dropdown-divider"></div>
        <a href="${pageContext.request.contextPath}/logout" class="dropdown-link danger">🚪 Đăng xuất</a>
    </div>
</div>

<!-- MODAL TẠO/SỬA VOUCHER -->
<div class="pob-modal-overlay ${not empty loi ? 'open' : ''}" id="voucherModal">
    <div class="pob-modal-box">
        <div class="modal-header">
            <div class="modal-title-wrap"><div class="m-name" id="modalTitle">${formAction == 'update' ? 'Sửa voucher' : 'Tạo voucher mới'}</div></div>
            <button type="button" class="modal-close" onclick="closeModal()">×</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/admin/vouchers" id="voucherForm">
            <input type="hidden" name="action" id="formAction" value="${not empty formAction ? formAction : 'create'}">
            <input type="hidden" name="id" id="formId" value="${voucherForm.id}">
            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group form-full">
                        <label class="form-label">Mã voucher <span class="required">*</span></label>
                        <input type="text" name="code" id="fCode" class="form-control" placeholder="VD: SALE50K"
                               value="${fn:escapeXml(voucherForm.code)}" required maxlength="50" style="text-transform:uppercase;">
                        <div class="form-hint">Chỉ chữ in hoa/số/gạch ngang, 3-50 ký tự.</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Loại giảm giá <span class="required">*</span></label>
                        <select name="voucherType" id="fType" class="form-select" onchange="onTypeChange()">
                            <option value="PERCENT" ${empty voucherForm.voucherType || voucherForm.voucherType == 'PERCENT' ? 'selected' : ''}>Giảm theo %</option>
                            <option value="FIXED" ${voucherForm.voucherType == 'FIXED' ? 'selected' : ''}>Giảm số tiền cố định</option>
                            <option value="FREESHIP" ${voucherForm.voucherType == 'FREESHIP' ? 'selected' : ''}>Miễn phí vận chuyển</option>
                        </select>
                    </div>
                    <div class="form-group" id="valueGroup">
                        <label class="form-label" id="valueLabel">Giá trị giảm (%) <span class="required">*</span></label>
                        <input type="number" name="value" id="fValue" class="form-control" min="0" step="1" value="${voucherForm.value}">
                    </div>
                    <div class="form-group" id="maxDiscountGroup">
                        <label class="form-label">Giảm tối đa (đ, chỉ áp dụng cho %)</label>
                        <input type="number" name="maxDiscount" id="fMaxDiscount" class="form-control" min="0" step="1000" value="${voucherForm.maxDiscount}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giá trị đơn tối thiểu (đ)</label>
                        <input type="number" name="minOrderValue" id="fMinOrderValue" class="form-control" min="0" step="1000" value="${not empty voucherForm ? voucherForm.minOrderValue : 0}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giới hạn lượt dùng (để trống = không giới hạn)</label>
                        <input type="number" name="usageLimit" id="fUsageLimit" class="form-control" min="1" step="1" value="${voucherForm.usageLimit}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ngày bắt đầu (để trống = áp dụng ngay)</label>
                        <input type="datetime-local" name="startDate" id="fStartDate" class="form-control" value="${voucherForm.startDate}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ngày kết thúc (để trống = không giới hạn)</label>
                        <input type="datetime-local" name="endDate" id="fEndDate" class="form-control" value="${voucherForm.endDate}">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-ghost" onclick="closeModal()">Huỷ</button>
                <button type="submit" class="btn btn-primary">💾 Lưu</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/dashboard-theme.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var avatarBtn = document.getElementById('avatarBtn');
        var avatarDropdown = document.getElementById('avatarDropdown');
        if (avatarBtn && avatarDropdown) {
            avatarBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                var rect = avatarBtn.getBoundingClientRect();
                avatarDropdown.style.top = (rect.bottom + 10) + 'px';
                avatarDropdown.style.right = (window.innerWidth - rect.right) + 'px';
                avatarDropdown.classList.toggle('open');
            });
            avatarDropdown.addEventListener('click', function(e) { e.stopPropagation(); });
            document.addEventListener('click', function() { avatarDropdown.classList.remove('open'); });
        }
    });

    var modal = document.getElementById('voucherModal');

    function onTypeChange() {
        var type = document.getElementById('fType').value;
        var valueGroup = document.getElementById('valueGroup');
        var maxDiscountGroup = document.getElementById('maxDiscountGroup');
        var valueLabel = document.getElementById('valueLabel');
        if (type === 'FREESHIP') {
            valueGroup.style.display = 'none';
            maxDiscountGroup.style.display = 'none';
        } else {
            valueGroup.style.display = '';
            maxDiscountGroup.style.display = type === 'PERCENT' ? '' : 'none';
            valueLabel.textContent = type === 'PERCENT' ? 'Giá trị giảm (%) *' : 'Số tiền giảm (đ) *';
        }
    }

    function openCreateModal() {
        document.getElementById('modalTitle').textContent = 'Tạo voucher mới';
        document.getElementById('formAction').value = 'create';
        document.getElementById('formId').value = '';
        document.getElementById('voucherForm').reset();
        onTypeChange();
        modal.classList.add('open');
    }

    function openEditModal(id, code, type, value, minOrderValue, maxDiscount, usageLimit, startDate, endDate) {
        document.getElementById('modalTitle').textContent = 'Sửa voucher #' + id;
        document.getElementById('formAction').value = 'update';
        document.getElementById('formId').value = id;
        document.getElementById('fCode').value = code;
        document.getElementById('fType').value = type;
        document.getElementById('fValue').value = value;
        document.getElementById('fMinOrderValue').value = minOrderValue;
        document.getElementById('fMaxDiscount').value = maxDiscount === null ? '' : maxDiscount;
        document.getElementById('fUsageLimit').value = usageLimit === null ? '' : usageLimit;
        document.getElementById('fStartDate').value = startDate ? startDate.substring(0, 16) : '';
        document.getElementById('fEndDate').value = endDate ? endDate.substring(0, 16) : '';
        onTypeChange();
        modal.classList.add('open');
    }

    function closeModal() { modal.classList.remove('open'); }
    modal.addEventListener('click', function(e) { if (e.target === modal) closeModal(); });

    <c:if test="${not empty loi}">
        onTypeChange();
    </c:if>
</script>
</body>
</html>
