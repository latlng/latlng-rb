# encoding: utf-8
## ------------------------------------------------------------------------  
##  Geodesy representation conversion functions (c) Chris Veness 2002-2010   
##   - www.movable-type.co.uk/scripts/latlong.html                           
##                                                                           
##  Sample usage:                                                            
##    var lat = Geo.parseDMS('51° 28′ 40.12″ N');                            
##    var lon = Geo.parseDMS('000° 00′ 05.31″ W');                           
##    var p1 = new LatLon(lat, lon);                                         
## ------------------------------------------------------------------------  

module Geo ## Geo namespace, representing static class
  class << self

    # Parse string representing degrees/minutes/seconds into numeric degrees
    # 
    #   This is very flexible on formats, allowing signed decimal degrees, or
    # deg-min-sec optionally suffixed by compass direction (NSEW). A variety of
    # separators are accepted (eg 3º 37' 09"W) or fixed-width format without
    # separators (eg 0033709W). Seconds and minutes may be omitted. 
    #  (Note minimal validation is done).
    # @param   {String|Number} dmsStr: Degrees or deg/min/sec in variety of formats
    # @returns {Number} Degrees as decimal number
    # @throws  {TypeError} dmsStr is an object, perhaps DOM object without .value?
    def parseDMS dmsStr
      
      ## check for a numeric value, if so return it directly
      if (dmsStr.is_a? Numeric and (f = dmsStr.to_f).finite?) 
        return dmsStr;
      end

      dmsStr = dmsStr.to_s.strip # convert whatever it is to a string.
      
      dms = dmsStr.split(/[^0-9.,]+/).reject{|d| d == ""}

      case dms.length
      when 3 ## interpret 3-part result as d/m/s
        dms.collect!{|d| d.to_f}
        deg = dms[0] / 1 + dms[1] / 60 + dms[2] / 3600; 
      when 2 ## interpret 2-part result as d/m
        dms.collect!{|d| d.to_f}
        deg = dms[0] / 1 + dms[1] / 60; 
      when 1 ## just d (possibly decimal) or non-separated dddmmss
        case dms[0]
        when /^(\d{2,3})(\d{2})$/
         ## fixed-width unseparated format eg 00337W
          deg = $1.to_f / 1 + $2.to_f / 60
        when /^(\d{1,3})(\d{2})(\d{2})$/
         ## fixed-width unseparated format eg 0033709W
          deg = $1.to_f / 1 + $2.to_f / 60 + $3.to_f / 3600; 
        else
          deg = dms[0].to_f;
        end
      else # unrecognised format
        return nil
      end
      
      if dmsStr.match /^-/ # negative 
        deg = -deg; ## take '-' as negative
      end

      if dmsStr.match /[WSws]$/ # west or south
        deg = -deg; ## take west and south as negative
      end

      deg # return degrees
    end # parseDMS

    # Convert decimal degrees to deg/min/sec format
    # - degree, prime, double-prime symbols are added, but sign is discarded,
    # though no compass direction is added
    # @param   {Number} deg: Degrees
    # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
    # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for
    # dms, 2 for dm, 4 for d
    # @returns {String} deg formatted as deg/min/secs according to specified
    # format
    def toDMS deg, format = 'dms', dp = nil
      deg = deg.to_f.abs
      case format
      when 'd'
        dp ||= 4
        d = deg.round(dp).to_s
        "#{d}\u00B0"
      when 'dm'
        dp ||= 2
        d, m = deg.to_f.abs.divmod(1)
        m = (m * 60).round(dp)
        "#{d}\u00B0#{m}\u2032"
      else
        dp ||= 0
        d, m = deg.to_f.abs.divmod(1)
        m, s = (m * 60).divmod(1)
        s = (s * 60).round(dp)
        "#{d}\u00B0#{m}\u2032#{s}\u2033"
      end
    end # toDMS

    # Convert numeric degrees to deg/min/sec latitude (suffixed with N/S)
    # @param   {Number} deg: Degrees
    # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
    # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for
    # dms, 2 for dm, 4 for d
    # @returns {String} Deg/min/seconds
    def toLat deg, format = 'dms', dp = nil
      lat = toDMS(deg, format, dp)
      deg < 0 ? "#{lat}S" : "#{lat}N"
    end

    # Convert numeric degrees to deg/min/sec longitude (suffixed with E/W)
    # @param   {Number} deg: Degrees
    # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
    # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for
    # dms, 2 for dm, 4 for d
    # @returns {String} Deg/min/seconds
    def toLon deg, format = 'dms', dp = nil
      lon = toDMS(deg, format, dp)
      deg < 0 ? "#{lon}W" : "#{lon}E"
    end

    # Convert numeric degrees to deg/min/sec as a bearing (0º..360º)
    # @param   {Number} deg: Degrees
    # @param   {String} [format=dms]: Return value as 'd', 'dm', 'dms'
    # @param   {Number} [dp=0|2|4]: No of decimal places to use - default 0 for
    # dms, 2 for dm, 4 for d
    # @returns {String} Deg/min/seconds
    def toBrng deg, format = 'dms', dp = nil
      deg = (deg.to_f + 360) % 360;  ## normalise -ve values to 180º..360º
      brng = Geo.toDMS(deg, format, dp)
      brng.sub('360', '0')  ## just in case rounding took us up to 360º!
    end
  
  end # class
end # Geo
