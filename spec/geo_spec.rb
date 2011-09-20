
require "./geo"

describe Geo do
  describe "parseDMS" do 
    it "returns the number it is passed" do
      Geo::parseDMS(3.5).should == 3.5
    end
  end
end

