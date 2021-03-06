class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :user_groups
  has_many :tasks

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :is_admin, :user_group_ids
  # attr_accessible :title, :body

  validates_presence_of :username, :email, :password, :password_confirmation

  def to_s
    "#{username}, #{email}#{' (admin)' if is_admin}"
  end

  def boards
    @boards = []
    user_groups.each do |group|
      @boards += group.boards
    end

    @boards
  end
end
