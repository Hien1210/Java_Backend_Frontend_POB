<%@ page pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Địa chỉ giao hàng - POB</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Inter', sans-serif; }
        .card-hover { transition: box-shadow .2s, transform .2s; }
        .card-hover:hover { box-shadow: 0 8px 24px rgba(0,0,0,.08); transform: translateY(-1px); }
        .modal-backdrop { transition: opacity .2s; }
        input:focus, select:focus, textarea:focus { outline: none; box-shadow: 0 0 0 3px rgba(39,49,85,.12); }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">

<%-- Navbar --%>
<div class="bg-white border-b shadow-sm px-6 py-4 flex items-center gap-4">
    <div class="w-9 h-9 rounded-xl flex items-center justify-center text-white font-extrabold text-sm"
         style="background:linear-gradient(135deg,#273155,#3d4f7c);">POB</div>
    <span class="text-lg font-extrabold text-gray-800">Địa chỉ giao hàng</span>
    <div class="ml-auto flex items-center gap-3">
        <a href="${pageContext.request.contextPath}/user/donhang"
           class="text-sm text-gray-500 hover:text-gray-800">📦 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/"
           class="text-sm text-gray-500 hover:text-gray-800">← Trang chủ</a>
    </div>
</div>

<div class="max-w-2xl mx-auto px-4 py-8">

    <%-- Thông báo --%>
    <c:if test="${param.success eq 'created'}">
        <div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 mb-5 text-sm font-medium">
            ✅ Đã thêm địa chỉ mới thành công!
        </div>
    </c:if>
    <c:if test="${param.success eq 'updated'}">
        <div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 mb-5 text-sm font-medium">
            ✅ Đã cập nhật địa chỉ thành công!
        </div>
    </c:if>
    <c:if test="${param.success eq 'deleted'}">
        <div class="bg-red-50 border border-red-200 text-red-700 rounded-xl px-4 py-3 mb-5 text-sm font-medium">
            🗑️ Đã xóa địa chỉ.
        </div>
    </c:if>
    <c:if test="${param.success eq 'default'}">
        <div class="bg-blue-50 border border-blue-200 text-blue-700 rounded-xl px-4 py-3 mb-5 text-sm font-medium">
            ⭐ Đã đặt làm địa chỉ mặc định!
        </div>
    </c:if>
    <c:if test="${param.error eq 'missing'}">
        <div class="bg-red-50 border border-red-200 text-red-700 rounded-xl px-4 py-3 mb-5 text-sm font-medium">
            ❌ Vui lòng điền đầy đủ thông tin bắt buộc.
        </div>
    </c:if>

    <%-- Header + nút thêm --%>
    <div class="flex items-center justify-between mb-5">
        <h2 class="text-xl font-extrabold text-gray-800">Địa chỉ của tôi</h2>
        <button onclick="openModal('modalCreate')"
                class="flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-bold text-white"
                style="background:linear-gradient(135deg,#273155,#3d4f7c);">
            + Thêm địa chỉ mới
        </button>
    </div>

    <%-- Danh sách địa chỉ --%>
    <c:choose>
        <c:when test="${empty addresses}">
            <div class="bg-white rounded-2xl border border-dashed border-gray-300 p-12 text-center text-gray-400">
                <div class="text-5xl mb-3">📍</div>
                <p class="font-semibold text-base">Bạn chưa có địa chỉ nào.</p>
                <p class="text-sm mt-1">Thêm địa chỉ để đặt hàng nhanh hơn.</p>
                <button onclick="openModal('modalCreate')"
                        class="mt-4 inline-block px-5 py-2 rounded-xl text-sm font-bold text-white"
                        style="background:linear-gradient(135deg,#273155,#3d4f7c);">
                    + Thêm địa chỉ mới
                </button>
            </div>
        </c:when>
        <c:otherwise>
            <div class="space-y-4">
                <c:forEach var="addr" items="${addresses}">
                    <div class="bg-white rounded-2xl border shadow-sm p-5 card-hover relative"
                         style="${addr.isDefault ? 'border-color:#60a5fa;' : 'border-color:#f3f4f6;'}">

                        <%-- Badge mặc định --%>
                        <c:if test="${addr.isDefault}">
                            <span class="absolute top-4 right-4 bg-blue-100 text-blue-700 text-xs font-bold px-3 py-1 rounded-full">
                                ⭐ Mặc định
                            </span>
                        </c:if>

                        <%-- Label --%>
                        <div class="flex items-center gap-2 mb-2">
                            <span class="text-base font-extrabold text-gray-800">
                                <c:choose>
                                    <c:when test="${addr.label eq 'Nhà'}">🏠</c:when>
                                    <c:when test="${addr.label eq 'Công ty'}">🏢</c:when>
                                    <c:when test="${addr.label eq 'Trường học'}">🎓</c:when>
                                    <c:otherwise>📍</c:otherwise>
                                </c:choose>
                                ${addr.label}
                            </span>
                        </div>

                        <%-- Thông tin --%>
                        <p class="text-sm text-gray-700 font-medium mb-1">📍 ${addr.fullAddress}</p>
                        <p class="text-sm text-gray-500">👤 ${addr.receiverName} &nbsp;|&nbsp; 📞 ${addr.receiverPhone}</p>

                        <%-- Actions --%>
                        <div class="flex gap-2 mt-4 flex-wrap">
                            <c:if test="${!addr.isDefault}">
                                <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="setDefault">
                                    <input type="hidden" name="id" value="${addr.id}">
                                    <button type="submit" class="text-xs font-semibold px-3 py-1.5 rounded-lg border border-blue-200 text-blue-600 hover:bg-blue-50">
                                        ⭐ Đặt mặc định
                                    </button>
                                </form>
                            </c:if>

                            <button onclick="openEdit(${addr.id}, '${addr.label}', '${addr.fullAddress}', '${addr.receiverName}', '${addr.receiverPhone}')"
                                    class="text-xs font-semibold px-3 py-1.5 rounded-lg border border-gray-200 text-gray-600 hover:bg-gray-50">
                                ✏️ Sửa
                            </button>

                            <c:if test="${!addr.isDefault}">
                                <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" style="display:inline;"
                                      onsubmit="return confirm('Xác nhận xóa địa chỉ này?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="${addr.id}">
                                    <button type="submit" class="text-xs font-semibold px-3 py-1.5 rounded-lg border border-red-200 text-red-500 hover:bg-red-50">
                                        🗑️ Xóa
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%-- ============ MODAL THÊM ============ --%>
<div id="modalCreate" class="fixed inset-0 bg-black/40 flex items-center justify-center z-50 hidden modal-backdrop px-4">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6">
        <div class="flex items-center justify-between mb-5">
            <h3 class="text-base font-extrabold text-gray-800">➕ Thêm địa chỉ mới</h3>
            <button onclick="closeModal('modalCreate')" class="text-gray-400 hover:text-gray-700 text-xl font-bold">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" class="space-y-4">
            <input type="hidden" name="action" value="create">

            <div>
                <label class="block text-xs font-bold text-gray-600 mb-1">Nhãn địa chỉ</label>
                <select name="label" class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50">
                    <option value="Nhà">🏠 Nhà</option>
                    <option value="Công ty">🏢 Công ty</option>
                    <option value="Trường học">🎓 Trường học</option>
                    <option value="Khác">📍 Khác</option>
                </select>
            </div>

            <div>
                <label class="block text-xs font-bold text-gray-600 mb-1">Địa chỉ đầy đủ <span class="text-red-500">*</span></label>
                <textarea name="fullAddress" rows="2" required placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"
                          class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 resize-none"></textarea>
            </div>

            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">Tên người nhận <span class="text-red-500">*</span></label>
                    <input type="text" name="receiverName" required placeholder="Họ và tên"
                           class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">Số điện thoại <span class="text-red-500">*</span></label>
                    <input type="tel" name="receiverPhone" required placeholder="0xxxxxxxxx"
                           class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50">
                </div>
            </div>

            <label class="flex items-center gap-2 text-sm text-gray-600 cursor-pointer">
                <input type="checkbox" name="isDefault" value="true" class="w-4 h-4 rounded accent-blue-600">
                <span>Đặt làm địa chỉ mặc định</span>
            </label>

            <div class="flex gap-3 pt-1">
                <button type="button" onclick="closeModal('modalCreate')"
                        class="flex-1 py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">
                    Hủy
                </button>
                <button type="submit"
                        class="flex-1 py-2.5 rounded-xl text-sm font-bold text-white"
                        style="background:linear-gradient(135deg,#273155,#3d4f7c);">
                    Lưu địa chỉ
                </button>
            </div>
        </form>
    </div>
</div>

<%-- ============ MODAL SỬA ============ --%>
<div id="modalEdit" class="fixed inset-0 bg-black/40 flex items-center justify-center z-50 hidden modal-backdrop px-4">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6">
        <div class="flex items-center justify-between mb-5">
            <h3 class="text-base font-extrabold text-gray-800">✏️ Chỉnh sửa địa chỉ</h3>
            <button onclick="closeModal('modalEdit')" class="text-gray-400 hover:text-gray-700 text-xl font-bold">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/user/dia-chi" method="post" class="space-y-4">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">

            <div>
                <label class="block text-xs font-bold text-gray-600 mb-1">Nhãn địa chỉ</label>
                <select name="label" id="editLabel" class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50">
                    <option value="Nhà">🏠 Nhà</option>
                    <option value="Công ty">🏢 Công ty</option>
                    <option value="Trường học">🎓 Trường học</option>
                    <option value="Khác">📍 Khác</option>
                </select>
            </div>

            <div>
                <label class="block text-xs font-bold text-gray-600 mb-1">Địa chỉ đầy đủ <span class="text-red-500">*</span></label>
                <textarea name="fullAddress" id="editFullAddress" rows="2" required
                          class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50 resize-none"></textarea>
            </div>

            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">Tên người nhận <span class="text-red-500">*</span></label>
                    <input type="text" name="receiverName" id="editReceiverName" required
                           class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">Số điện thoại <span class="text-red-500">*</span></label>
                    <input type="tel" name="receiverPhone" id="editReceiverPhone" required
                           class="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm bg-gray-50">
                </div>
            </div>

            <div class="flex gap-3 pt-1">
                <button type="button" onclick="closeModal('modalEdit')"
                        class="flex-1 py-2.5 rounded-xl border border-gray-200 text-sm font-semibold text-gray-600 hover:bg-gray-50">
                    Hủy
                </button>
                <button type="submit"
                        class="flex-1 py-2.5 rounded-xl text-sm font-bold text-white"
                        style="background:linear-gradient(135deg,#273155,#3d4f7c);">
                    Cập nhật
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(id) { document.getElementById(id).classList.remove('hidden'); }
    function closeModal(id) { document.getElementById(id).classList.add('hidden'); }

    // Click backdrop để đóng
    ['modalCreate','modalEdit'].forEach(id => {
        document.getElementById(id).addEventListener('click', function(e) {
            if (e.target === this) closeModal(id);
        });
    });

    function openEdit(id, label, fullAddress, receiverName, receiverPhone) {
        document.getElementById('editId').value           = id;
        document.getElementById('editFullAddress').value  = fullAddress;
        document.getElementById('editReceiverName').value = receiverName;
        document.getElementById('editReceiverPhone').value= receiverPhone;
        const sel = document.getElementById('editLabel');
        for (let opt of sel.options) { opt.selected = opt.value === label; }
        openModal('modalEdit');
    }
</script>
</body>
</html>
