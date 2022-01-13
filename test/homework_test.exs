defmodule HomeworkTest do
  # Import helpers
  import Hound.RequestUtils
  use Hound.Helpers
  use ExUnit.Case

  # Start hound session and destroy when tests are run
  hound_session()

  # test "Drag and Drop" do
  # navigate_to("https://the-internet.herokuapp.com/drag_and_drop")
  # columnA = find_element(:id, "column-a")
  # columnB = find_element(:id, "column-b")

  # bLocation = element_location(columnB)
  # aLocation = element_location(columnB)
  # move_to(columnA, elem(aLocation, 0), elem(aLocation, 1))
  # mouse_down(0)
  # move_to(columnB, elem(bLocation, 0), elem(bLocation, 1))
  # mouse_up(0)
  # end

  # Hovers over three different user images and validates the users names that populate the screen
  test "Hovers" do
    navigate_to("https://the-internet.herokuapp.com/hovers")

    try do
      userOne =
        find_element(
          :css,
          "body > div:nth-child(2) > div:nth-child(2) > div:nth-child(2) > div:nth-child(3) > img:nth-child(1)"
        )

      userTwo =
        find_element(
          :css,
          "body > div:nth-child(2) > div:nth-child(2) > div:nth-child(2) > div:nth-child(4) > img:nth-child(1)"
        )

      userThree = find_element(:css, "div:nth-child(3) img:nth-child(1)")

      userOneLocation = element_location(userOne)
      userTwoLocation = element_location(userTwo)
      userThreeLocation = element_location(userThree)

      move_to(userOne, elem(userOneLocation, 0), elem(userOneLocation, 1))
      nameOne = find_element(:xpath, "//h5[normalize-space()='name: user1']")
      assert element_displayed?(nameOne) == true

      move_to(userTwo, elem(userTwoLocation, 0), elem(userTwoLocation, 1))
      nameTwo = find_element(:xpath, "//h5[normalize-space()='name: user2']")
      assert element_displayed?(nameTwo) == true

      move_to(userThree, elem(userThreeLocation, 0), elem(userThreeLocation, 1))
      nameThree = find_element(:xpath, "//div[3]//img[1]")
      assert element_displayed?(nameThree) == true
    catch
      kind, error ->
        take_screenshot()
        raise error
    end
  end

  # Test that tests different key presses and compars the string returned stating key pressed
  test "Key Presses" do
    navigate_to("https://the-internet.herokuapp.com/key_presses")

    try do
      buttonField = find_element(:css, "#target")
      displayed = element_displayed?(buttonField)
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
      kind, error ->
        take_screenshot()
        raise error
    end
  end

  # Test for switching between iframs on a page
  test "Nested Frames" do
    navigate_to("https://the-internet.herokuapp.com/nested_frames")

    try do
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
      rightFrameTxt = visible_text(rightBody)
      assert rightFrameTxt == "RIGHT"
      focus_parent_frame()

      # Selects bottom iframe and verifys text
      focus_parent_frame()
      iframeBtm = find_element(:name, "frame-bottom")
      focus_frame(iframeBtm)
      bottomBody = find_element(:tag, "body")
      btmFrameTxt = visible_text(bottomBody)
      assert btmFrameTxt == "BOTTOM"
    catch
      kind, error ->
        take_screenshot()
        raise error
    end
  end
end
