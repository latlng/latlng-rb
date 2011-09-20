# encoding: utf-8
#
require "./geo"

describe Geo do
  describe "parseDMS" do 
    it "returns the number it is passed" do
      Geo.parseDMS(3.5).should == 3.5
    end
    it "should parse deg-min-sec suffixed with N/S/E/W" do 
      Geo.parseDMS("40°44′55″N").should == 40.74861111111111
      Geo.parseDMS("40°44′55″S").should == -40.74861111111111
      Geo.parseDMS("40°44′55″").should == 40.74861111111111
      Geo.parseDMS("-40°44′55″").should == -40.74861111111111
      Geo.parseDMS("73 59 11E").should == 73.9863888888889
      Geo.parseDMS("73 59 11W").should == -73.9863888888889
      Geo.parseDMS("73/59/11E").should == 73.9863888888889
      Geo.parseDMS("73/59/11W").should == -73.9863888888889
      Geo.parseDMS("51° 28′ 40.12″ N").should == 51.477811111111116
      Geo.parseDMS("51° 28′ 40.12″ S").should == -51.477811111111116
    end
    it "should parse fixed-width format without separators" do 
      Geo.parseDMS("0033709W").should == -3.6191666666666666
      Geo.parseDMS("00337W").should == -3.6166666666666667
      Geo.parseDMS("40°N").should == 40.0
    end
    it "should parse decimal format with N/S/E/W" do 
      Geo.parseDMS("27.389N").should == 27.389
      Geo.parseDMS("27.389S").should == -27.389
      Geo.parseDMS("27.389E").should == 27.389
      Geo.parseDMS("27.389W").should == -27.389
      Geo.parseDMS("-27.389").should == -27.389
    end
    it "should handle a double negative" do 
      Geo.parseDMS("-27.389S").should == 27.389
    end
    it "should gracefully handle non numeric input" do 
      Geo.parseDMS("FRED").should == nil
    end
  end
  describe "toDMS" do
    it "should format a number in degrees, minutes and seconds" do
      Geo.toDMS(51.477811111111116).should == "51°28′40″"
      Geo.toDMS(51.477811111111116,'dms').should == "51°28′40″"
      Geo.toDMS(51.477811111111116,'dms',2).should == "51°28′40.12″"
    end
    it "should format a number in degrees and minutes" do
      Geo.toDMS(51.477811111111116,'dm').should == "51°28.67′"
      Geo.toDMS(51.477811111111116,'dm',0).should == "51°29′"
      Geo.toDMS(51.477811111111116,'dm',2).should == "51°28.67′"
    end
    it "should format a number in degrees" do
      Geo.toDMS(51.477811111111116,'d').should == "51.4778°"
      Geo.toDMS(51.477811111111116,'d',0).should == "51°"
      Geo.toDMS(51.477811111111116,'d',4).should == "51.4778°"
    end
  end
  describe "toLat" do
    it "should format a number in degrees, minutes and seconds" do
      Geo.toLat(51.477811111111116).should == "51°28′40″N"
      Geo.toLat(51.477811111111116,'dms').should == "51°28′40″N"
      Geo.toLat(51.477811111111116,'dms',2).should == "51°28′40.12″N"
      Geo.toLat(-51.477811111111116).should == "51°28′40″S"
      Geo.toLat(-51.477811111111116,'dms').should == "51°28′40″S"
      Geo.toLat(-51.477811111111116,'dms',2).should == "51°28′40.12″S"
    end
    it "should format a number in degrees and minutes" do
      Geo.toLat(51.477811111111116,'dm').should == "51°28.67′N"
      Geo.toLat(51.477811111111116,'dm',0).should == "51°29′N"
      Geo.toLat(51.477811111111116,'dm',2).should == "51°28.67′N"
      Geo.toLat(-51.477811111111116,'dm').should == "51°28.67′S"
      Geo.toLat(-51.477811111111116,'dm',0).should == "51°29′S"
      Geo.toLat(-51.477811111111116,'dm',2).should == "51°28.67′S"
    end
    it "should format a number in degrees" do
      Geo.toLat(51.477811111111116,'d').should == "51.4778°N"
      Geo.toLat(51.477811111111116,'d',0).should == "51°N"
      Geo.toLat(51.477811111111116,'d',4).should == "51.4778°N"
      Geo.toLat(-51.477811111111116,'d').should == "51.4778°S"
      Geo.toLat(-51.477811111111116,'d',0).should == "51°S"
      Geo.toLat(-51.477811111111116,'d',4).should == "51.4778°S"
    end
  end
  describe "toLon" do
    it "should format a number in degrees, minutes and seconds" do
      Geo.toLon(51.477811111111116).should == "51°28′40″E"
      Geo.toLon(51.477811111111116,'dms').should == "51°28′40″E"
      Geo.toLon(51.477811111111116,'dms',2).should == "51°28′40.12″E"
      Geo.toLon(-51.477811111111116).should == "51°28′40″W"
      Geo.toLon(-51.477811111111116,'dms').should == "51°28′40″W"
      Geo.toLon(-51.477811111111116,'dms',2).should == "51°28′40.12″W"
    end
    it "should format a number in degrees and minutes" do
      Geo.toLon(51.477811111111116,'dm').should == "51°28.67′E"
      Geo.toLon(51.477811111111116,'dm',0).should == "51°29′E"
      Geo.toLon(51.477811111111116,'dm',2).should == "51°28.67′E"
      Geo.toLon(-51.477811111111116,'dm').should == "51°28.67′W"
      Geo.toLon(-51.477811111111116,'dm',0).should == "51°29′W"
      Geo.toLon(-51.477811111111116,'dm',2).should == "51°28.67′W"
    end
    it "should format a number in degrees" do
      Geo.toLon(51.477811111111116,'d').should == "51.4778°E"
      Geo.toLon(51.477811111111116,'d',0).should == "51°E"
      Geo.toLon(51.477811111111116,'d',4).should == "51.4778°E"
      Geo.toLon(-51.477811111111116,'d').should == "51.4778°W"
      Geo.toLon(-51.477811111111116,'d',0).should == "51°W"
      Geo.toLon(-51.477811111111116,'d',4).should == "51.4778°W"
    end
  end
  describe "toBrng" do
    it "should format a number in degrees, minutes and seconds" do
      Geo.toBrng(51.477811111111116).should == "51°28′40″"
      Geo.toBrng(51.477811111111116,'dms').should == "51°28′40″"
      Geo.toBrng(51.477811111111116,'dms',2).should == "51°28′40.12″"
    end
    it "should format a number in degrees and minutes" do
      Geo.toBrng(51.477811111111116,'dm').should == "51°28.67′"
      Geo.toBrng(51.477811111111116,'dm',0).should == "51°29′"
      Geo.toBrng(51.477811111111116,'dm',2).should == "51°28.67′"
    end
    it "should format a number in degrees" do
      Geo.toBrng(51.477811111111116,'d').should == "51.4778°"
      Geo.toBrng(51.477811111111116,'d',0).should == "51°"
      Geo.toBrng(51.477811111111116,'d',4).should == "51.4778°"
    end
    it "should normalize values to 0..360 degrees" do
      Geo.toBrng(-450).should == "270°0′0″"
      Geo.toBrng(-360).should == "0°0′0″"
      Geo.toBrng(-270).should == "90°0′0″"
      Geo.toBrng(-180).should == "180°0′0″"
      Geo.toBrng(-90).should == "270°0′0″"
      Geo.toBrng(0).should == "0°0′0″"
      Geo.toBrng(90).should == "90°0′0″"
      Geo.toBrng(180).should == "180°0′0″"
      Geo.toBrng(270).should == "270°0′0″"
      Geo.toBrng(360).should == "0°0′0″"
      Geo.toBrng(450).should == "90°0′0″"
    end
  end
end

