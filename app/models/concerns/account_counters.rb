# frozen_string_literal: true

module AccountCounters
  extend ActiveSupport::Concern

  included do
    has_one :account_stat, inverse_of: :account
    after_save :save_account_stat
  end

  def statuses_count
    account_stat&.statuses_count || 0
  end

  def statuses_count=(val)
    (account_stat || build_account_stat).statuses_count = val
  end

  def following_count
    account_stat&.following_count || 0
  end

  def following_count=(val)
    (account_stat || build_account_stat).following_count = val
  end

  def followers_count
    account_stat&.followers_count || 0
  end

  def followers_count=(val)
    (account_stat || build_account_stat).followers_count = val
  end

  def increment_count!(key)
    update_account_stat!(key => public_send(key) + 1)
  end

  def decrement_count!(key)
    update_account_stat!(key => [public_send(key) - 1, 0].max)
  end

  private

  def update_account_stat!(attrs)
    return if destroyed?

    record = account_stat || build_account_stat
    record.update(attrs)
  end

  def save_account_stat
    return unless account_stat&.changed?
    account_stat.save
  end
end
