user = User.create!(name: 'guest', screen_name: 'guest', email: 'guest@example.com',
  profile: 'ゲストアカウントです。', uid: '0nKeqJ8ONhQzCYWonssULmJYs2E2',
  guest: true
)

user.create_experience!
user.create_setting!
