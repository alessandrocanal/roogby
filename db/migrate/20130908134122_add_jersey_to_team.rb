class AddJerseyToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :jersey, :string
  end
end
