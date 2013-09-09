class AddFieldsToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :long_name, :string
    add_column :competitions, :short_name, :string
  end
end
