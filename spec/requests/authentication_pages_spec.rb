require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do
    before { visit signin_path }

    it { should have_title('Sign in') }
    it { should have_selector('input#session_email') }
    it { should have_selector('input#session_password') }
    it { should have_selector('input.btn.btn-primary') }
    it { should have_link('Sign up now!', href: signup_path) }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-danger') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-danger') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      
      it { should have_title("Hotel Advisor") }
      it { should have_link('Profile',     href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in / Sign up', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }

        it { should have_title("Hotel Advisor") }
        it { should_not have_link('Profile',     href: edit_user_path(user)) }
        it { should_not have_link('Sign out',    href: signout_path) }
        it { should have_link('Sign in / Sign up', href: signin_path) }
      end
    end

  end

  describe "signup" do
    before { visit signup_path }

    it { should have_title('Sign up') }
    it { should have_selector('input#user_name') }
    it { should have_selector('input#user_email') }
    it { should have_selector('input#user_password') }
    it { should have_selector('input#user_password_confirmation') }
    it { should have_selector('input.btn.btn-primary') }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button "Save" }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: 'Example User'
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button "Save" }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button "Save" }
        let(:user) { User.find_by(email: 'user@example.com') }
                
        it { should have_title("Hotel Advisor") }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Profile',     href: edit_user_path(user)) }
        it { should have_link('Sign out',    href: signout_path) }
        it { should_not have_link('Sign in / Sign up', href: signin_path) }              
      end

    end
  end


  

end