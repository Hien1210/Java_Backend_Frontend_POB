var EARTH_RADIUS_KM = 6371;
var AVG_SHIPPER_SPEED_KMH = 30;

function trackingHaversineKm(lat1, lng1, lat2, lng2) {
    if (lat1 == null || lng1 == null || lat2 == null || lng2 == null) {
        return null;
    }
    var toRad = function (deg) { return deg * Math.PI / 180; };
    var dLat = toRad(lat2 - lat1);
    var dLng = toRad(lng2 - lng1);
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
        Math.sin(dLng / 2) * Math.sin(dLng / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return EARTH_RADIUS_KM * c;
}

function trackingFormatDistance(km) {
    if (km == null) return '—';
    return km < 1 ? Math.round(km * 1000) + ' m' : km.toFixed(1) + ' km';
}

function trackingFormatEta(km) {
    if (km == null) return '—';
    var minutes = Math.max(1, Math.round((km / AVG_SHIPPER_SPEED_KMH) * 60));
    return minutes + ' phút';
}

function initOrderTrackingMap(containerId, shopLat, shopLng, destLat, destLng, wsUrl) {
    var container = document.getElementById(containerId);
    if (!container || container._trackingMap) {
        return;
    }

    var map = L.map(containerId);
    container._trackingMap = map;

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '&copy; OpenStreetMap'
    }).addTo(map);

    var bounds = [];
    var shopMarker = null;
    var destMarker = null;
    var shipperMarker = null;

    if (shopLat != null && shopLng != null) {
        var shopIcon = L.divIcon({className: 'shop-marker-icon', html: '🏪', iconSize: [24, 24], iconAnchor: [12, 12]});
        shopMarker = L.marker([shopLat, shopLng], {icon: shopIcon, zIndexOffset: 1000}).addTo(map).bindPopup('🏪 Cửa hàng');
        bounds.push([shopLat, shopLng]);
    }
    if (destLat != null && destLng != null) {
        destMarker = L.marker([destLat, destLng]).addTo(map).bindPopup('🏠 Điểm giao');
        bounds.push([destLat, destLng]);
    }

    if (bounds.length > 0) {
        map.fitBounds(bounds, {padding: [30, 30]});
    } else {
        map.setView([21.0278, 105.8342], 13);
    }

    setTimeout(function () {
        map.invalidateSize();
    }, 0);

    var infoPanel = document.createElement('div');
    infoPanel.className = 'tracking-distance-info';
    infoPanel.style.cssText = 'margin-top:6px;padding:6px 10px;border-radius:6px;' +
        'background:rgba(37,99,235,.08);color:#1d4ed8;font-size:12px;font-weight:600;' +
        'display:flex;flex-wrap:wrap;gap:10px;justify-content:center;';
    if (container.parentNode) {
        container.parentNode.insertBefore(infoPanel, container.nextSibling);
    }

    function updateInfoPanel(shipperLat, shipperLng) {
        var parts = [];
        var shopDest = trackingHaversineKm(shopLat, shopLng, destLat, destLng);
        if (shopDest != null) {
            parts.push('🏪→🏠 ' + trackingFormatDistance(shopDest));
        }
        if (shipperLat != null) {
            var shipperDest = trackingHaversineKm(shipperLat, shipperLng, destLat, destLng);
            var shopShipper = trackingHaversineKm(shopLat, shopLng, shipperLat, shipperLng);
            if (shopShipper != null) {
                parts.push('🏪→🛵 ' + trackingFormatDistance(shopShipper));
            }
            if (shipperDest != null) {
                parts.push('🛵→🏠 ' + trackingFormatDistance(shipperDest) + ' (ETA ~' + trackingFormatEta(shipperDest) + ')');
            }
        }
        infoPanel.innerHTML = parts.length ? parts.join(' &nbsp;|&nbsp; ') : '';
    }

    updateInfoPanel(null, null);

    var staleNotice = document.createElement('div');
    staleNotice.className = 'tracking-stale-notice';
    staleNotice.style.cssText = 'display:none;margin-top:6px;padding:6px 10px;border-radius:6px;' +
        'background:rgba(239,68,68,.12);color:#dc2626;font-size:12px;font-weight:600;text-align:center;';
    staleNotice.textContent = '⚠️ Mất kết nối theo dõi trực tiếp — vị trí shipper có thể không còn cập nhật.';
    if (container.parentNode) {
        container.parentNode.insertBefore(staleNotice, container.nextSibling);
    }

    function showStaleNotice() {
        staleNotice.style.display = 'block';
    }

    var socket = new WebSocket(wsUrl);
    socket.addEventListener('message', function (event) {
        var data = JSON.parse(event.data);
        var latlng = [data.lat, data.lng];

        if (shipperMarker === null) {
            shipperMarker = L.marker(latlng, {
                icon: L.divIcon({className: 'shop-marker-icon', html: '🛵', iconSize: [24, 24], iconAnchor: [12, 12]}),
                zIndexOffset: 2000
            }).addTo(map).bindPopup('🛵 Shipper');
        } else {
            shipperMarker.setLatLng(latlng);
        }

        var allBounds = bounds.slice();
        allBounds.push(latlng);
        map.fitBounds(allBounds, {padding: [30, 30]});

        updateInfoPanel(data.lat, data.lng);
    });

    socket.addEventListener('close', showStaleNotice);
    socket.addEventListener('error', showStaleNotice);

    window.addEventListener('beforeunload', function () {
        if (socket.readyState === WebSocket.OPEN || socket.readyState === WebSocket.CONNECTING) {
            socket.close();
        }
    });
}
