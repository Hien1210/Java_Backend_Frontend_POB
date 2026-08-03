package org.example.daos;

import org.example.models.SystemConfig;

public interface SystemConfigDAO {
    /** Lấy dòng tham số vận hành hiện tại (id = 1). Nếu chưa có sẽ trả về giá trị mặc định. */
    SystemConfig get();

    /** Lưu (update) toàn bộ tham số vận hành vào dòng id = 1. */
    boolean save(SystemConfig config);
}
