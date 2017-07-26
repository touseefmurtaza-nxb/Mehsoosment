json.success "true"
json.message ""
json.data do
  json.id @room.id
  json.current_page @current_page
  json.next_page @next_page
  json.last_page @total_pages
  json.total_msgs @total_msgs_count
  json.created_at @room.created_at
  json.updated_at @room.updated_at
  json.room_messages do
    json.array! @room.messages.order("messages.created_at").paginate(:page => $current_page, :per_page => $per_page).as_json(include: [:sender, :receiver])
  end
end
json.status 200