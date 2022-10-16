# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.boolean :like, default: false, null: false
      t.boolean :hate, default: false, null: false

      t.belongs_to :user, index: true
      t.belongs_to :movie, index: true
      t.timestamps
    end
  end
end
