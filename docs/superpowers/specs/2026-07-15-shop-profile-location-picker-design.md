# Shop Profile Location Picker — Design

**Date:** 2026-07-15
**Status:** Approved (pending user sign-off on this doc)

## Problem

The shop-side delivery-map feature (completed earlier: `HoaDonShop.jsp`,
`Quanlybill.jsp`) shows a 🏠 marker for the shop's own registered location,
using `Shop.locationX`/`locationY`. But there is currently **no way for a
shop to ever set those coordinates**:

- `Shops.locationX`/`locationY` columns already exist in the DB
  (`Database.md:173-174`, type `DECIMAL(18,10)`).
- `Shop.java` already has the `locationX`/`locationY` fields + getters/setters.
- `ShopDAOImpl.mapResultSetToShop()` never reads these columns from the
  `ResultSet`, and `ShopDAOImpl.updateShop()` never writes them in its
  `UPDATE Shops SET ...` statement.
- `ShopProfileServlet` (`/shop/profile`, backing `Shopprofile.jsp` — the
  "Thông tin cửa hàng" page) never reads/sets `locationX`/`locationY` on the
  `Shop` object it saves.

Net effect: `currentShop.locationX/locationY` is always `null` in practice,
so the 🏠 marker on the delivery maps never actually renders for any shop.

The user's request: add a map to the "Thông tin cửa hàng" page so the shop
can see (and set) where its own location is.

## Decision: editable picker, not read-only display

A read-only map would have nothing to show, since no shop has ever been able
to set a location. The fix must let the shop **set** its coordinates, so this
adds an **editable location picker** to `Shopprofile.jsp`'s existing edit
form — the same interaction pattern already used for user addresses in
`diaChi.jsp` (click-to-place / drag pin, address search box via Nominatim,
hidden lat/lng inputs, fallback center Hà Nội `21.0285, 105.8542`).

Unlike address creation (`diaChi.jsp`), the location field stays **optional**:
saving the shop profile must not be blocked by a missing location, since
existing shops already have valid profiles with no coordinates set.

## Scope

1. **`ShopDAOImpl`** — wire `locationX`/`locationY` end-to-end:
   - `mapResultSetToShop()`: read columns `locationX`/`locationY` (the
     `Shops` table uses camelCase for these two columns, per
     `Database.md:173-174` — unlike its other snake_case columns) via
     `rs.getObject(...)`/`getBigDecimal(...)`, converting to `Double`,
     null-safe.
   - `updateShop()`: add `locationX = ?, locationY = ?` to the `UPDATE`
     statement, using `setObject(..., Types.DECIMAL)` or
     `setBigDecimal`/`setNull` for a possibly-null `Double`.

2. **`ShopProfileServlet`** — in `doPost`, parse optional
   `shopLocationX`/`shopLocationY` request params (blank → `null`, matching
   the existing `parseDoubleOrNull`-style helper used in `CheckoutServlet`);
   set them on `shop` before calling `shopDAO.updateShop(shop)`. Also set
   them on the `formShop` fallback object in the validation-failure branch
   so the picked location isn't lost if `shopName`/`shopAddress`/`shopPhone`
   validation fails and the form re-renders.

3. **`Shopprofile.jsp`** — add a new form field block (after the existing
   "Địa chỉ" field, before "Số điện thoại") inside the existing
   `<form id="shopProfileForm">`:
   - Leaflet 1.9.4 CDN tags (same as the two delivery-map pages).
   - A "📍 Chọn vị trí trên bản đồ" toggle button revealing a map + search
     box, reusing `diaChi.jsp`'s `initAddressMap`/`toggleMap` JS pattern
     verbatim (function names scoped to this page to avoid confusion, e.g.
     `initShopLocationMap`/`toggleShopLocationMap`), pre-filled from
     `formShop.locationX`/`locationY` if present.
   - Hidden inputs `name="shopLocationX"`/`name="shopLocationY"` populated
     by the map (not `required` — optional field).
   - No `validateAddressForm`-style submit guard, since the field is optional.

## Out of scope

- No DB schema changes (columns already exist).
- No changes to `Shop.java` model (fields already exist).
- No changes to the two delivery-map pages from the prior feature — they
  already correctly read `currentShop.locationX/locationY`; this spec just
  makes that value stop being `null`.
- No admin-side shop-location editing.

## Testing

No automated test framework in this project. Verification:
- Full-project `javac` compile (standard command used in prior tasks).
- Manual: on `/shop/profile`, pick a location on the map, save, reload the
  page — the map should re-open pre-filled at the saved coordinates. Then
  open `/shop/bills` (Quanlybill.jsp) or a bill detail (HoaDonShop.jsp) for
  an order with coordinates and confirm the 🏠 shop marker now renders.
