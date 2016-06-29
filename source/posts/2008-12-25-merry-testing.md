---
title: "Merry Testing"
author: "Caius Durling"
created_at: 2008-12-25 15:01:54 +0000
tags:
  - "geek"
  - "tech"
  - "ruby"
  - "php"
  - "programming"
  - "code"
  - "rspec"
  - "phpunit"
  - "objective-c"
  - "ocunit"
  - "test::unit"
---

Just a few examples of the same test written in a few languages. Its testing setting the date on an object that is created in the tests' setup method already. These fall under the unit testing, rather than full-stack testing.

### Testing in ObjC with [OCUnit](http://www.sente.ch/software/ocunit/)

    // Add a date and time
    - (void)testSettingDate
    {    
        NSDate *theDate = [NSDate date];        
        
        STAssertNoThrow([calc setDate:theDate], @"Shouldn't raise an exception");
        // And it should match when pulled out as well
        STAssertEqualObjects([calc date], theDate,
                             @"%@ should match %@",
                             [calc date], theDate);

    }

### Testing in Ruby using [RSpec](http://rspec.info/)

    it "should set the date successfully" do
      the_date = Date.today

      @calc.date = the_date
      # And it should match when pulled out as well
      @calc.date.should == the_date
    end

### Testing in Ruby using [Test::Unit](http://www.ruby-doc.org/stdlib/libdoc/test/unit/rdoc/classes/Test/Unit.html)

    def test_setting_date
      the_date = Date.today
      @calc.date = the_date
      # And it should match when pulled out as well
      assert_equal(@calc.date, the_date)
    end

### Testing in PHP using [PHPUnit](http://phpun.it/)

    function testSettingDate()
    {
        $date = date();
        $calc->date = $date;
        # And it should match when pulled out as well
        $this->assertEquals($calc->date, $date);
    }

