package org.example.daos;

import org.example.models.AccountAppeal;
import org.example.utils.DBUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AppealDAOImpl implements AppealDAO {

    @Override
    public boolean submit(long accountId, String message) {
        String sql = "INSERT INTO Account_Appeals (account_id, message, status, created_at) VALUES (?, ?, 'PENDING', GETDATE())";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setLong(1, accountId);
            pst.setString(2, message);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean hasPendingAppeal(long accountId) {
        String sql = "SELECT COUNT(*) FROM Account_Appeals WHERE account_id = ? AND status = 'PENDING'";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setLong(1, accountId);
            try (ResultSet rs = pst.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<AccountAppeal> findAll() {
        return query("SELECT aa.*, a.username, a.full_name, a.email, a.suspend_reason, a.status AS account_status " +
                "FROM Account_Appeals aa JOIN Accounts a ON a.id = aa.account_id " +
                "ORDER BY aa.created_at DESC");
    }

    @Override
    public List<AccountAppeal> findPending() {
        return query("SELECT aa.*, a.username, a.full_name, a.email, a.suspend_reason, a.status AS account_status " +
                "FROM Account_Appeals aa JOIN Accounts a ON a.id = aa.account_id " +
                "WHERE aa.status = 'PENDING' ORDER BY aa.created_at ASC");
    }

    @Override
    public AccountAppeal findById(long id) {
        String sql = "SELECT aa.*, a.username, a.full_name, a.email, a.suspend_reason, a.status AS account_status " +
                "FROM Account_Appeals aa JOIN Accounts a ON a.id = aa.account_id WHERE aa.id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setLong(1, id);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean approve(long id, long accountId, String adminNote) {
        String updateAppeal = "UPDATE Account_Appeals SET status='APPROVED', admin_note=?, reviewed_at=GETDATE() WHERE id=?";
        String restoreAccount = "UPDATE Accounts SET is_deleted=0, suspend_reason=NULL, status='ACTIVE', bom_count=0 WHERE id=?";
        try (Connection con = DBUtil.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement p1 = con.prepareStatement(updateAppeal);
                 PreparedStatement p2 = con.prepareStatement(restoreAccount)) {
                p1.setString(1, adminNote);
                p1.setLong(2, id);
                p1.executeUpdate();
                p2.setLong(1, accountId);
                p2.executeUpdate();
                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean reject(long id, String adminNote) {
        String sql = "UPDATE Account_Appeals SET status='REJECTED', admin_note=?, reviewed_at=GETDATE() WHERE id=?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setString(1, adminNote);
            pst.setLong(2, id);
            return pst.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public int countPending() {
        String sql = "SELECT COUNT(*) FROM Account_Appeals WHERE status = 'PENDING'";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private List<AccountAppeal> query(String sql) {
        List<AccountAppeal> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private AccountAppeal map(ResultSet rs) throws SQLException {
        AccountAppeal a = new AccountAppeal();
        a.setId(rs.getLong("id"));
        a.setAccountId(rs.getLong("account_id"));
        a.setMessage(rs.getString("message"));
        a.setStatus(rs.getString("status"));
        a.setAdminNote(rs.getString("admin_note"));
        a.setUsername(rs.getString("username"));
        a.setFullName(rs.getString("full_name"));
        a.setEmail(rs.getString("email"));
        a.setSuspendReason(rs.getString("suspend_reason"));
        try { a.setAccountStatus(rs.getString("account_status")); } catch (SQLException ignored) {}
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) a.setCreatedAt(created.toLocalDateTime());
        Timestamp reviewed = rs.getTimestamp("reviewed_at");
        if (reviewed != null) a.setReviewedAt(reviewed.toLocalDateTime());
        return a;
    }
}
