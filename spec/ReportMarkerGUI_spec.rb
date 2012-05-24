require 'spec_helper'

describe ReportMarkerGUI do
  before(:each) do
    @gui = ReportMarkerGUI.new
  end
  
  describe '#requirements_marks' do
    before(:each) do
      @gui.load_from_layout
    end
    context 'when no marks awarded' do
      it 'totals 0' do
        @gui.requirements_marks.inject(:+).should eq 0
      end
    end
    context 'when mark 1 awarded' do
      before(:each) do
        @gui.builder["checkbutton_r1"].active = true
      end
      it "totals 1" do
        @gui.requirements_marks.inject(:+).should eq 1
      end
      it "returns a 0 at all positions except 0" do
        @gui.requirements_marks.each_with_index do |mark, index|
          mark.should eq 0 unless index ==  0
        end
      end
      context 'when mark 2 awarded' do
        before(:each) do
          @gui.builder["checkbutton_r2"].active = true
        end
        it "totals 2" do
          @gui.requirements_marks.inject(:+).should eq 2
        end
        context 'when mark 1 awarded' do
          before(:each) do
            @gui.builder["checkbutton_r1"].active = true
          end
          it "totals 2" do
            @gui.requirements_marks.inject(:+).should eq 2
          end
        end
      end
    end
    context 'when mark 2 awarded' do
      before(:each) do
        @gui.builder["checkbutton_r2"].active = true
      end
      it "totals 1" do
        @gui.requirements_marks.inject(:+).should eq 1
      end
    end
  end
  
  describe '#analysis_marks' do
    before(:each) do
      @gui.load_from_layout
    end
    it 'consists of 7 marks' do
      @gui.analysis_marks.length.should eq 7
    end
    context 'when only mark 1 awarded' do
      before(:each) do
        @gui.builder["checkbutton_a1"].active = true
      end
      it 'totals 1' do
        @gui.analysis_marks.inject(:+).should eq 1
      end
      it "returns a 0 at all positions except 0" do
        @gui.analysis_marks.each_with_index do |mark, index|
          mark.should eq 0 unless index ==  0
        end
      end
    end
  end
  
  describe '#specification_marks' do
    before(:each) do
      @gui.load_from_layout
    end
    it 'consists of 3 marks' do
      @gui.specification_marks.length.should eq 3
    end
    context 'when only mark 1 awarded' do
      before(:each) do
        @gui.builder["checkbutton_s1"].active = true
      end
      it "totals 1" do
        @gui.specification_marks.inject(:+).should eq 1
      end
      it "returns a 1 at position 0" do
        @gui.specification_marks[0].should eq 1
      end
      it "returns a 0 at position 1" do
        @gui.specification_marks[1].should eq 0
      end
      it "returns a 0 at position 2" do
        @gui.specification_marks[2].should eq 0
      end
    end
  end
  
  describe '#design_marks' do
     before(:each) do
      @gui.load_from_layout
    end
    it 'consists of 11 marks' do
      @gui.design_marks.length.should eq 11
    end
    context 'when only mark 1 awarded' do
      before(:each) do
        @gui.builder["checkbutton_d1"].active = true
      end
      it "totals 1" do
        @gui.design_marks.inject(:+).should eq 1
      end
      it "returns a 1 at position 0" do
        @gui.design_marks[0].should eq 1
      end
      it "returns a 0 at position 1" do
        @gui.design_marks[1].should eq 0
      end
      it "returns a 0 at position 2" do
        @gui.design_marks[2].should eq 0
      end
      it "returns a 0 at all positions except 0" do
        @gui.design_marks.each_with_index do |mark, index|
          mark.should eq 0 unless index ==  0
        end
      end
    end
  end

  describe '#implementation_marks' do
    before(:each) do
      @gui.load_from_layout
    end
    it 'consists of 3 marks' do
      @gui.implementation_marks.length.should eq 3
    end
    context 'when only mark 1 awarded' do
      before(:each) do
        @gui.builder["checkbutton_i1"].active = true
      end
      it "totals 1" do
        @gui.implementation_marks.inject(:+).should eq 1
      end
      it "returns a 1 at position 0" do
        @gui.implementation_marks[0].should eq 1
      end
      it "returns a 0 at position 1" do
        @gui.implementation_marks[1].should eq 0
      end
      it "returns a 0 at position 2" do
        @gui.implementation_marks[2].should eq 0
      end
    end
    context 'when only mark 2 awarded' do
      before(:each) do
        @gui.builder["checkbutton_i2"].active = true
      end
      it "totals 1" do
        @gui.implementation_marks.inject(:+).should eq 1
      end
      it "returns a 0 at position 0" do
        @gui.implementation_marks[0].should eq 0
      end
      it "returns a 1 at position 1" do
        @gui.implementation_marks[1].should eq 1
      end
      it "returns a 0 at position 2" do
        @gui.implementation_marks[2].should eq 0
      end
    end
    context 'when only mark 3 awarded' do
      before(:each) do
        @gui.builder["checkbutton_i3"].active = true
      end
      it "totals 1" do
        @gui.implementation_marks.inject(:+).should eq 1
      end
      it "returns a 0 at position 0" do
        @gui.implementation_marks[0].should eq 0
      end
      it "returns a 0 at position 1" do
        @gui.implementation_marks[1].should eq 0
      end
      it "returns a 1 at position 2" do
        @gui.implementation_marks[2].should eq 1
      end
    end
    context 'when all marks awarded' do
      it 'totals 3' do
        @gui.builder["checkbutton_i1"].active = true
        @gui.builder["checkbutton_i2"].active = true
        @gui.builder["checkbutton_i3"].active = true
        @gui.implementation_marks.inject(:+).should eq 3
      end
    end
  end
  
  describe '#code_listing_marks' do
    before(:each) do
      @gui.load_from_layout
    end
    it 'consists of 11 marks' do
      @gui.code_listing_marks.length.should eq 11
    end
    context 'when only mark 1 awarded' do
      before(:each) do
        @gui.builder["checkbutton_cl1"].active = true
      end
      it "totals 1" do
        @gui.code_listing_marks.inject(:+).should eq 1
      end
      it "returns a 1 at position 0" do
        @gui.code_listing_marks[0].should eq 1
      end
      it "returns a 0 at all positions except 0" do
        @gui.code_listing_marks.each_with_index do |mark, index|
          mark.should eq 0 unless index ==  0
        end
      end
    end
    context 'when only one mark 2 awarded' do
      before(:each) do
        @gui.builder["checkbutton_cl2"].active = true
      end
      it "totals 1" do
        @gui.code_listing_marks.inject(:+).should eq 1
      end
      it "returns a 1 at position 1" do
        @gui.code_listing_marks[1].should eq 1
      end
      it "returns a 0 at all positions except 1" do
        @gui.code_listing_marks.each_with_index do |mark, index|
          mark.should eq 0 unless index ==  1
        end
      end
    end
    context 'when two marks for 2 awarded' do
      it 'totals 2 when marks 2-1 and 2-2' do
        @gui.builder["checkbutton_cl2"].active = true
        @gui.builder["checkbutton_cl2_2"].active = true
        @gui.code_listing_marks.inject(:+).should eq 2
      end
      it 'totals 2 when marks 2-1 and 2-3' do
        @gui.builder["checkbutton_cl2"].active = true
        @gui.builder["checkbutton_cl2_3"].active = true
        @gui.code_listing_marks.inject(:+).should eq 2
      end
      it 'totals 2 when marks 2-2 and 2-3' do
        @gui.builder["checkbutton_cl2_2"].active = true
        @gui.builder["checkbutton_cl2_3"].active = true
        @gui.code_listing_marks.inject(:+).should eq 2
      end
    end
    context 'when all marks awarded' do
      it 'totals 21' do
        @gui.builder["checkbutton_cl1"].active = true
        @gui.builder["checkbutton_cl2"].active = true
        @gui.builder["checkbutton_cl2_2"].active = true
        @gui.builder["checkbutton_cl2_3"].active = true
        @gui.builder["checkbutton_cl3"].active = true
        @gui.builder["checkbutton_cl3_2"].active = true
        @gui.builder["checkbutton_cl4"].active = true
        @gui.builder["checkbutton_cl4_2"].active = true
        @gui.builder["checkbutton_cl5"].active = true
        @gui.builder["checkbutton_cl6"].active = true
        @gui.builder["checkbutton_cl7"].active = true
        @gui.builder["checkbutton_cl8"].active = true
        @gui.builder["checkbutton_cl8_2"].active = true
        @gui.builder["checkbutton_cl8_3"].active = true
        @gui.builder["checkbutton_cl9"].active = true
        @gui.builder["checkbutton_cl9_2"].active = true
        @gui.builder["checkbutton_cl9_3"].active = true
        @gui.builder["checkbutton_cl9_3"].active = true
        @gui.builder["checkbutton_cl10"].active = true
        @gui.builder["checkbutton_cl10_2"].active = true
        @gui.builder["checkbutton_cl11"].active = true
        @gui.builder["checkbutton_cl11_2"].active = true
        
        @gui.code_listing_marks.inject(:+).should eq 21
      end
    end
  end
  
  describe '#testing_and_verification_marks' do
    before(:each) do
      @gui.load_from_layout
    end
    it 'consists of 5 marks' do
      @gui.testing_and_verification_marks.length.should eq 5
    end
    context 'when only mark 1 awarded' do
      before(:each) do
        @gui.builder["checkbutton_tv1"].active = true
      end
      it 'totals 1' do
        @gui.testing_and_verification_marks.inject(:+).should eq 1
      end
      it 'returns a 1 at position 0' do
        @gui.testing_and_verification_marks[0].should eq 1
      end
      it "returns a 0 at all positions except 0" do
        @gui.testing_and_verification_marks.each_with_index do |mark, index|
          mark.should eq 0 unless index ==  0
        end
      end
    end
    
  end
end
