package org.example.models;

import java.time.LocalDateTime;

public class BannedWord {
    private long id;
    private String word;
    private LocalDateTime createdAt;

    public BannedWord() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getWord() { return word; }
    public void setWord(String word) { this.word = word; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
