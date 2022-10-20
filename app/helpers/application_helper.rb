module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_by && sort_dir == "desc") ? "desc" : "asc"
    link_to t('sort.created_at'), :sort => column, :direction => direction
  end
end
