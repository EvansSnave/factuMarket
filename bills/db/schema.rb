# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_14_165233) do
  create_table "aq$_schedules", primary_key: ["oid", "destination"], force: :cascade do |t|
    t.raw "oid", limit: 16, null: false
    t.string "destination", limit: 390, null: false
    t.date "start_time"
    t.string "duration", limit: 8
    t.string "next_time", limit: 128
    t.string "latency", limit: 8
    t.date "last_time"
    t.decimal "jobno"
    t.index ["jobno"], name: "aq$_schedules_check", unique: true
  end

  create_table "bills", force: :cascade do |t|
    t.integer "user_id", precision: 38
    t.string "description"
    t.integer "amount", precision: 38
    t.string "product"
    t.date "bill_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "help", primary_key: ["topic", "seq"], force: :cascade do |t|
    t.string "topic", limit: 50, null: false
    t.decimal "seq", null: false
    t.string "info", limit: 80
  end

  create_table "mview$_adv_ajg", primary_key: "ajgid#", id: :decimal, comment: "Anchor-join graph representation", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "ajgdeslen", null: false
    t.raw "ajgdes", null: false
    t.decimal "hashvalue", null: false
    t.decimal "frequency"
  end

  create_table "mview$_adv_basetable", id: false, comment: "Base tables refered by a query", force: :cascade do |t|
    t.decimal "collectionid#", null: false
    t.decimal "queryid#", null: false
    t.string "owner", limit: 128
    t.string "table_name", limit: 128
    t.decimal "table_type"
    t.index ["queryid#"], name: "mview$_adv_basetable_idx_01"
  end

  create_table "mview$_adv_clique", primary_key: "cliqueid#", id: :decimal, comment: "Table for storing canonical form of Clique queries", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "cliquedeslen", null: false
    t.raw "cliquedes", null: false
    t.decimal "hashvalue", null: false
    t.decimal "frequency", null: false
    t.decimal "bytecost", null: false
    t.decimal "rowsize", null: false
    t.decimal "numrows", null: false
  end

  create_table "mview$_adv_eligible", primary_key: ["sumobjn#", "runid#"], comment: "Summary management rewrite eligibility information", force: :cascade do |t|
    t.decimal "sumobjn#", null: false
    t.decimal "runid#", null: false
    t.decimal "bytecost", null: false
    t.decimal "flags", null: false
    t.decimal "frequency", null: false
  end

  create_table "mview$_adv_filter", primary_key: ["filterid#", "subfilternum#"], comment: "Table for workload filter definition", force: :cascade do |t|
    t.decimal "filterid#", null: false
    t.decimal "subfilternum#", null: false
    t.decimal "subfiltertype", null: false
    t.string "str_value", limit: 1028
    t.decimal "num_value1"
    t.decimal "num_value2"
    t.date "date_value1"
    t.date "date_value2"
  end

  create_table "mview$_adv_filterinstance", id: false, comment: "Table for workload filter instance definition", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "filterid#"
    t.decimal "subfilternum#"
    t.decimal "subfiltertype"
    t.string "str_value", limit: 1028
    t.decimal "num_value1"
    t.decimal "num_value2"
    t.date "date_value1"
    t.date "date_value2"
  end

  create_table "mview$_adv_fjg", primary_key: "fjgid#", id: :decimal, comment: "Representation for query join sub-graph not in AJG ", force: :cascade do |t|
    t.decimal "ajgid#", null: false
    t.decimal "fjgdeslen", null: false
    t.raw "fjgdes", null: false
    t.decimal "hashvalue", null: false
    t.decimal "frequency"
  end

  create_table "mview$_adv_gc", primary_key: "gcid#", id: :decimal, comment: "Group-by columns of a query", force: :cascade do |t|
    t.decimal "fjgid#", null: false
    t.decimal "gcdeslen", null: false
    t.raw "gcdes", null: false
    t.decimal "hashvalue", null: false
    t.decimal "frequency"
  end

  create_table "mview$_adv_info", primary_key: ["runid#", "seq#"], comment: "Internal table for passing information from the SQL analyzer", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "seq#", null: false
    t.decimal "type", null: false
    t.decimal "infolen", null: false
    t.raw "info"
    t.decimal "status"
    t.decimal "flag"
  end

  create_table "mview$_adv_level", primary_key: ["runid#", "levelid#"], comment: "Level definition", force: :cascade do |t|
    t.decimal "runid#", null: false
    t.decimal "levelid#", null: false
    t.decimal "dimobj#"
    t.decimal "flags", null: false
    t.decimal "tblobj#", null: false
    t.raw "columnlist", limit: 70, null: false
    t.string "levelname", limit: 128
  end

  create_table "mview$_adv_log", primary_key: "runid#", id: :decimal, comment: "Log all calls to summary advisory functions", force: :cascade do |t|
    t.decimal "filterid#"
    t.date "run_begin"
    t.date "run_end"
    t.decimal "run_type"
    t.string "uname", limit: 128
    t.decimal "status", null: false
    t.string "message", limit: 2000
    t.decimal "completed"
    t.decimal "total"
    t.string "error_code", limit: 20
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "identification", precision: 38
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
