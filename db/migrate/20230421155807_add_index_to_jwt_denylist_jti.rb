class AddIndexToJwtDenylistJti < ActiveRecord::Migration[7.0]
  def change
    add_index :jwt_denylist, :jti
  end
end
