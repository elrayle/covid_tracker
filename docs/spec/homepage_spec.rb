describe "homepage", type: :feature, js: true do
  it "is accessible" do
    visit '/'
    expect(find('h1.post-title-main').text).to match /Covid Region Tracker/
  end
end
