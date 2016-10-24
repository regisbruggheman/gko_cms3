perms = create_permission('calendar', 'admin/calendars', false)
perms.each do |p|
  @admin_group.permission_groups.create(:permission => p)
end
perms = create_permission('calendar', 'admin/events', false)
perms.each do |p|
  @admin_group.permission_groups.create(:permission => p)
end