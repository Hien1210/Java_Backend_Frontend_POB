package org.example.daos;

import org.example.models.AccountAppeal;
import java.util.List;

public interface AppealDAO {
    boolean submit(long accountId, String message);
    boolean hasPendingAppeal(long accountId);
    List<AccountAppeal> findAll();
    List<AccountAppeal> findPending();
    AccountAppeal findById(long id);
    boolean approve(long id, long accountId, String adminNote);
    boolean reject(long id, String adminNote);
    int countPending();
}
