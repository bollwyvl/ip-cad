casper.test.begin "Widget: CAD", ->
  casper.notebook_test ->
    @then ->
      @execute_cell @append_cell """
        from IPython.display import display
        from ipcad.widgets import CAD
        cad = CAD(value="2000-01-01")""",
        "code"
  
    @wait_for_idle()

    @then ->
      @test.assertEval(
        -> IPython.WidgetManager._view_types.CADView != null
        "...registered"
      )
      @test.assertExists "link[href*='CADView.css']",
        "...style loaded"
  
    @then ->
      @execute_cell @append_cell "display(cad)", "code"

    @wait_for_idle()

    @then ->
      @test.assertEval(
        -> $(".widget-subarea input").val() == "2000-01-01"
        "...initialized with value"
      )

    @wait_for_idle()

    @thenEvaluate ->
      $(".widget-subarea input").val("1999-09-09").trigger("input")

    @wait_for_idle()

    @then ->
      @execute_cell @append_cell "cad.value", "code"

    @wait_for_output 2

    @then ->
      @test.assertEquals "1999-09-09", @get_output_cell(2),
        "...changes backend value"