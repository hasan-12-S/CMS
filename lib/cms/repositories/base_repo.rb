# frozen_string_literal: true
module Cms
  class BaseRepo
    def initialize(store, id_gen: IdGenerator.new); @store, @id_gen, @cache = store, id_gen, nil end
    def all; load_cache; @cache.dup end
    def find(id); all.find { |e| e[:id] == id } end
    def create(attrs); load_cache; rec = attrs.merge(id: @id_gen.next_id); @cache << rec; persist!; rec end
    def update(id, attrs); load_cache; idx = @cache.index { |e| e[:id] == id }; return nil unless idx; @cache[idx] = @cache[idx].merge(attrs); persist!; @cache[idx] end
    def delete(id); load_cache; before = @cache.length; @cache.reject! { |e| e[:id] == id }; persist! if @cache.length != before; before != @cache.length end
    def count; all.length end
    private
    def load_cache; return if @cache; @cache = @store.read_all.map { |h| symbolize(h) } end
    def persist!; @store.write_all(@cache) end
    def symbolize(h); h.transform_keys { |k| k.to_sym } end
  end
end
