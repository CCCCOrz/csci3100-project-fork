class NormalizeUserLocations < ActiveRecord::Migration[8.1]
  LEGACY_LOCATION_MAPPINGS = {
    "chung chi" => "Chung Chi College",
    "chung chi college" => "Chung Chi College",
    "new asia" => "New Asia College",
    "new asia college" => "New Asia College",
    "united" => "United College",
    "united college" => "United College",
    "shaw" => "Shaw College",
    "shaw college" => "Shaw College",
    "morningside" => "Morningside College",
    "morningside college" => "Morningside College",
    "s.h. ho" => "S.H. Ho College",
    "s.h. ho college" => "S.H. Ho College",
    "cw chu" => "CW Chu College",
    "cw chu college" => "CW Chu College",
    "wu yee sun" => "Wu Yee Sun College",
    "wu yee sun college" => "Wu Yee Sun College",
    "lee woo sing" => "Lee Woo Sing College",
    "lee woo sing college" => "Lee Woo Sing College"
  }.freeze

  def up
    LEGACY_LOCATION_MAPPINGS.each do |legacy_value, canonical_value|
      execute <<~SQL.squish
        UPDATE users
        SET location = #{connection.quote(canonical_value)}
        WHERE LOWER(TRIM(location)) = #{connection.quote(legacy_value)}
      SQL
    end
  end

  def down
  end
end
