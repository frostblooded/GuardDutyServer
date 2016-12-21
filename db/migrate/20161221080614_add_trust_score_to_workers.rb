class AddTrustScoreToWorkers < ActiveRecord::Migration[5.0]
  def change
    add_column :workers, :trust_score, :float, default: 100.0
  end
end
