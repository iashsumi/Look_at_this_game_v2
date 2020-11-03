# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_03_041916) do

  create_table "commentators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "site_kbn", limit: 1, null: false, comment: "動画のサイトのenum"
    t.string "user_id", null: false, comment: "動画のサイト上のユーザーID"
    t.string "name", null: false
    t.string "thumbnail_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_commentators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "commentator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentator_id"], name: "index_game_commentators_on_commentator_id"
    t.index ["game_id"], name: "index_game_commentators_on_game_id"
  end

  create_table "games", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", comment: "ゲームタイトル"
    t.integer "kind", comment: "機種"
    t.datetime "release_date_at", comment: "発売日"
    t.string "publisher", comment: "販売元"
    t.text "description", comment: "説明"
    t.string "description_video_id", comment: "紹介用の動画のID"
    t.string "thumbnail", comment: "ゲームのサムネ"
    t.string "comments", comment: "ゲームへのコメントまとめ（S3のパスを保持する予定)"
    t.string "thread_name", comment: "2chのスレタイ"
    t.text "thread_url", comment: "2chのスレのURL"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sc_boards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title"
    t.text "threads_url", comment: "スレッド一覧のURL"
    t.text "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sc_thread_keywords", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "sc_thread_id"
    t.string "word", comment: "キーワード"
    t.integer "appearances", comment: "キーワードの出現回数"
    t.boolean "is_used", comment: "キーワードを使用するかどうか"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sc_thread_id"], name: "index_sc_thread_keywords_on_sc_thread_id"
  end

  create_table "sc_threads", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "sc_board_id"
    t.string "title"
    t.text "url"
    t.text "thumbnail_url"
    t.datetime "thread_created_at", comment: "スレッド内の1番目の投稿の時間"
    t.integer "res", comment: "レスの数"
    t.decimal "momentum", precision: 10, scale: 3, comment: "勢い"
    t.boolean "is_completed", comment: "スレのデータを取得ずみかどうか(trueのデータのみフロントに返す)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sc_board_id"], name: "index_sc_threads_on_sc_board_id"
  end

  create_table "videos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "commentator_id"
    t.string "content_id", null: false
    t.string "title", null: false
    t.string "link", null: false, comment: "動画のURL"
    t.text "description", null: false
    t.string "thumbnail_url", null: false
    t.datetime "published_at", null: false, comment: "公開日"
    t.bigint "view_count", null: false, comment: "再生回数"
    t.string "momentum", comment: "勢い"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentator_id"], name: "index_videos_on_commentator_id"
  end

end
