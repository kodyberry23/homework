defmodule HomeworkTest do
  # Import helpers
  import Hound.RequestUtils
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  test "Drag and Drop" do
    navigate_to("https://the-internet.herokuapp.com/drag_and_drop")
    columnA = find_element(:id, "column-a")
    columnB = find_element(:id, "column-b")

    bLocation = element_location(columnB)
    aLocation = element_location(columnB)

    move_to(columnA, elem(aLocation, 1), elem(aLocation, 1))
    mouse_down(0)
    move_to(columnB, elem(bLocation, 1), elem(bLocation, 1))
    mouse_up(0)
  end

  # Checks to see if on the correct page and if it is looks for Remove or add button and clicks it.
  test "Inputs" do
    navigate_to("https://the-internet.herokuapp.com/inputs")

    numField = find_element(:css, "input[type='number']")
    displayed = element_displayed?(numField)

    if displayed === true do
      click(numField)

      send_keys(:up_arrow)

      num =
        execute_script("document.querySelector(arguments[0]).value;", [
          "input[type='number']"
        ])

      assert num == 1
    end

    unless true do
    end
  end

  # Test that tests different key presses and compars the string returned.
  test "Key Presses" do
    navigate_to("https://the-internet.herokuapp.com/key_presses")

    buttonField = find_element(:css, "#target")
    displayed = element_displayed?(buttonField)

    try do
      randBtn = Enum.random([:up_arrow, :shift, :num0, :num6])
      send_keys(randBtn)

      # Compares button press against returned string to verify they match.
      cond do
        randBtn == :up_arrow ->
          responseTxt = find_element(:css, "#result")
          response = visible_text(responseTxt)
          assert response == "You entered: UP"

        randBtn == :shift ->
          responseTxt = find_element(:css, "#result")
          response = visible_text(responseTxt)
          assert response == "You entered: SHIFT"

        randBtn == :num0 ->
          responseTxt = find_element(:css, "#result")
          response = visible_text(responseTxt)
          assert response == "You entered: NUMPAD0"

        randBtn == :num6 ->
          responseTxt = find_element(:css, "#result")
          response = visible_text(responseTxt)
          assert response == "You entered: NUMPAD6"
      end
    catch
      error ->
        take_screenshot("/Users/kodyberry/Desktop/Homework/homework/screen_shots")
        raise error
    end
  end

  # Test for switching between iframs on a page
  test "Nested Frames" do
    try do
      navigate_to("https://the-internet.herokuapp.com/nested_frames")

      iframeTop = find_element(:name, "frame-top")
      focus_frame(iframeTop)

      # Selects left iframe and verifys text
      iframeLeft = find_element(:name, "frame-left")
      focus_frame(iframeLeft)
      leftBody = find_element(:tag, "body")
      leftFrameTxt = visible_text(leftBody)
      assert leftFrameTxt == "LEFT"
      focus_parent_frame()

      # Selects middle iframe and verifys text
      iframeMiddle = find_element(:name, "frame-middle")
      focus_frame(iframeMiddle)
      middleBody = find_element(:tag, "body")
      middleFrameTxt = visible_text(middleBody)
      assert middleFrameTxt == "MIDDLE"
      focus_parent_frame()

      # Selects right iframe and verifys text
      iframeRight = find_element(:name, "frame-right")
      focus_frame(iframeRight)
      rightBody = find_element(:tag, "body")
      rightrameTxt = visible_text(rightBody)
      assert rightrameTxt == "RIGHT"
      focus_parent_frame()

      # Selects bottom iframe and verifys text
      focus_parent_frame()
      iframeBtm = find_element(:name, "frame-bottom")
      focus_frame(iframeBtm)
      bottomBody = find_element(:tag, "body")
      btmFrameTxt = visible_text(bottomBody)
      assert btmFrameTxt == "BOTTOM"
    catch
      error ->
        take_screenshot("/Users/kodyberry/Desktop/Homework/homework/screen_shots")
        raise error
    end
  end
end
