require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'g_viz', 'g_viz')

describe GViz do
  
  describe 'api' do
    describe 'graph' do
      @games = [{:name => "Gary", :games_won => "2", :birthday => "2008-02-01"},
               {:name => "John", :games_won => "4", :birthday => Date.parse("2009-01-01 11:11")},
               {:name => "A", :games_won => "2", :birthday => "Jun 14 1982"}]
      GViz.add_graph('MotionGraph', @games, [[:name, "Name"], [:games_won, "# Games"]])
    end
  end
  
  describe 'implementation details - class methods' do
    describe 'google_data_type' do
      it "should classify ruby data types to google visualization data types" do
        GViz.google_data_type(Time.now).should == 'datetime'
        GViz.google_data_type(Date.new).should == 'date'
        GViz.google_data_type("June 23 1982").should == 'date'
        GViz.google_data_type("June 23 1982 12:23").should == 'datetime'
        GViz.google_data_type("12312412").should == 'numeric'
        GViz.google_data_type("12312412.1234").should == 'numeric'
        GViz.google_data_type(1234123).should == 'numeric'
        GViz.google_data_type(1234123.1234).should == 'numeric'
        GViz.google_data_type("a123124123").should == 'string'
        # should this really happen?  documenting it because i need to think if this is ok.
        GViz.google_data_type("a12312412").should == 'date'
      end
    end
  end
  
  describe 'implmentation details - instances methods' do
    before(:all) do
      @games = [{:name => "Gary", :games_won => "2", :birthday => "2008-02-01"},
               {:name => "John", :games_won => "4", :birthday => Date.parse("2009-01-01 11:11")},
               {:name => "A", :games_won => "2", :birthday => "Jun 14 1982"}]
               
      @rows = [["'Gary'", "2", Date.parse("2008-02-01")],
               ["'John'", "4", Date.parse("2009-01-01")],
               ["'A'", "2", Date.parse("1982-06-14")]]
               
      @gviz = GViz.send(:new, 'bar', @games, [[:name, "Name"], [:games_won, "Games Won"], [:birthday, 'Birthday']])
    end
    describe 'columns' do
      it 'should return google data types and labels' do
        @gviz.columns.should == [['string', 'Name'], ['numeric', 'Games Won'], ['date', 'Birthday']]
      end
    
    end
    
    describe 'rows' do
      it 'should return data rows' do
        @gviz.rows.should == @rows
      end
    end
    
  end
end