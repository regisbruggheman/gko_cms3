perms = create_permission('comments', 'admin/comments', false)
perms.each do |p|
  @admin_group.permission_groups.create(:permission => p)
end