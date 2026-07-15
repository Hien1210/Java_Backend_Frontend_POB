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
        shopMarker = L.marker([shopLat, shopLng]).addTo(map).bindPopup('🏪 Cửa hàng');
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

    var socket = new WebSocket(wsUrl);
    socket.addEventListener('message', function (event) {
        var data = JSON.parse(event.data);
        var latlng = [data.lat, data.lng];

        if (shipperMarker === null) {
            shipperMarker = L.marker(latlng, {
                icon: L.divIcon({className: '', html: '🛵', iconSize: [24, 24]})
            }).addTo(map).bindPopup('🛵 Shipper');
        } else {
            shipperMarker.setLatLng(latlng);
        }

        var allBounds = bounds.slice();
        allBounds.push(latlng);
        map.fitBounds(allBounds, {padding: [30, 30]});
    });

    window.addEventListener('beforeunload', function () {
        if (socket.readyState === WebSocket.OPEN || socket.readyState === WebSocket.CONNECTING) {
            socket.close();
        }
    });
}
