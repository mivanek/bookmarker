require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Test User", email: "email@user.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  let(:blank_field) { ["", " ", nil] }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when the password is not present" do
    it do
      blank_field.each do |passwrd|
        @user.password = @user.password_confirmation = passwrd
        should_not be_valid
      end
    end
  end

  describe "when the password is too short" do
    before { @user.password = "a" * 5 }
    it { should_not be_valid }
  end

  describe "when passwords don't match" do
    before { @user.password_confirmation = "blah" }
    it { should_not be_valid }
  end

  describe "when password confirmation is blank" do
    it do
      blank_field.each do |passwrd|
        @user.password_confirmation = passwrd
        should_not be_valid
      end
    end
  end

  describe "when the username is not present" do
    it do
      blank_field.each do |usrname|
        @user.name = usrname
        should_not be_valid
      end
    end
  end

  describe "when the username is too long" do
    before { @user.name = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo,
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        should be_valid
      end
    end
  end

  describe "when there are duplicate emails" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end
end
