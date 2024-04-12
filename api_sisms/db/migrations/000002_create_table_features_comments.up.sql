CREATE TABLE IF NOT EXISTS features_comments (
    feature_id BIGINT NOT NULL,
    comment    TEXT NOT NULL CHECK ( LENGTH(TRIM(comment)) > 0 ),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (feature_id) REFERENCES features (id)
)