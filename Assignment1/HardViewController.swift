//
//  HardViewController.swift
//  Assignment1
//
//  Created by saj panchal on 2020-02-17.
//  Copyright © 2020 saj panchal. All rights reserved.
//

import UIKit
import AVFoundation //framwork for audio video operations
class HardViewController: UIViewController {

   
      var sliderInt : Int = 0
      var scoreInt : Int = 0
      var trailsCountInt : Int = 0
      var differenceInt : Int = 0
      var randomInt : Int = 0
      var sound: AVAudioPlayer?
      var flag: Int = 0
      var fileName: String?
      var fiftyMilestone: Int = 0
      var milestoneDiff: Int = 0
      
      @IBOutlet weak var trailLabel1: UILabel!
      @IBOutlet weak var trailLabel2: UILabel!
      @IBOutlet weak var trailLabel3: UILabel!
      @IBOutlet weak var totalScoreLabel: UILabel!
      @IBOutlet weak var randomNumberLabel: UILabel!
      @IBOutlet weak var slider: UISlider!
      @IBOutlet weak var alertView: UIView!
      @IBOutlet weak var alertLabel1: UILabel!
      @IBOutlet weak var alertLabel2: UILabel!
      @IBOutlet weak var alertLabel3: UILabel!
      
      @IBAction func slideIt(_ sender: Any)
      {
      }
      
      @IBOutlet weak var messageLabel: UILabel!
      @IBOutlet weak var tryButtonOutlet: UIButton!
      @IBOutlet weak var resetButtonOutlet: UIButton!
      @IBOutlet weak var checkButtonOutlet: UIButton!
      
      override func viewDidLoad()
         {
             super.viewDidLoad()
             resetGame()
         }
      
      @IBAction func tryButton(_ sender   : Any)
      {
          if(tryButtonOutlet.tag != 1) //Check if the try button is not pressed for more than once
          {
          randomInt = Int.random(in: 0...500) //Random function to generate a number from 0 to 500.
          randomNumberLabel.text = String(randomInt)
          }
          else
          {
              messageLabel.text = "Please slide and press check now..."
          }
          tryButtonOutlet.tag = 1
      }
      
      @IBAction func checkButton(_ sender: Any)
      {
          if(trailsCountInt < 3 && tryButtonOutlet.tag == 1) //check if the try button is pressed and at least one trail is left
          {
              tryButtonOutlet.tag = 0
              sliderInt = Int(slider.value)
              differenceInt = abs(randomInt - sliderInt) //absolute difference between random number and slider value
              pointsCalc(diffInt: differenceInt) // function to calculate points
              totalScoreLabel.text = String(scoreInt)
              milestoneDiff = abs((fiftyMilestone * 50) - scoreInt) //expression to detect if the total is crossed 50's milestone
            if(milestoneDiff >= 50) //check if the difference is 50 or more
            {
                generateAlert(viewColor: "green") //function to generate alert view with message
                fiftyMilestone += 1  //increment 50's multiplier
                
            }
          }
          else if (tryButtonOutlet.tag != 1)
          {
              messageLabel.text = "Please press try to play!"
          }
          else //if all trails lost
          {
              generateAlert(viewColor: "red") //function to generate alert with view
              scoreInt = 0
              fiftyMilestone = 0
              messageLabel.text = "Game over! Reset to start a new game."
          }
      }
      
      @IBAction func resetButton(_ sender: Any)
      {
          resetGame()
      }
      
      @IBAction func infoButton(_ sender: Any)
      {
      }
    
    /*----------------------------------------------Function------------------------------------------------*/
    /*Function to reset the game*/
     func resetGame() -> Void
     {
         scoreInt = 0
         slider.value = 0
         trailsCountInt = 0
         randomNumberLabel.text = "0"
         totalScoreLabel.text = "0"
         fiftyMilestone = 0
         milestoneDiff = 0
         tryButtonOutlet.tag = 0
         messageLabel.text = "Let's play"
         trailLabel1.isHidden = false
         trailLabel2.isHidden = false
         trailLabel3.isHidden = false
        // alertView.isHidden = true
     }
     /* Function for calculating the points based on differences*/
     func pointsCalc(diffInt: Int) -> Void
     {
         switch diffInt {
         case 0,1: //if the score difference is -1+
             generateSound(fileName: "win-win.mp3")
             scoreInt += 5 //accumulate the total score
             messageLabel.text = "+5 points!"
             slider.value = 0 //move slider to 0 position
         case 2,3: // if the score difference is -3+
             generateSound(fileName: "win-win.mp3")
             scoreInt += 4
             messageLabel.text = "+4 points!"
             slider.value = 0
         case 4,5: // if the score difference is -5+
             generateSound(fileName: "win-win.mp3")
             scoreInt += 3
             messageLabel.text = "+3 points!"
             slider.value = 0
         case 6...10: // if the score difference is -10+
            generateSound(fileName: "win-win.mp3")
             scoreInt += 1
             messageLabel.text = "+1 points!"
             slider.value = 0
         case 11...500: //if the score difference is -500+
             generateSound(fileName: "beep.mp3")
             trailsCountInt += 1
             scoreInt += 0
             slider.value = 0
             trailsCheck(trails: trailsCountInt) //function to check and deduct the trails
         default:
             generateSound(fileName: "beep.mp3")
             messageLabel.text = "Please slide and Press Try..."
             slider.value = 0
         }
     }
     
    /* function to generate view alert */
    func generateAlert(viewColor : String) -> Void
     {
         if(viewColor == "red")
         {
             generateSound(fileName: "Game-over-robotic-voice.mp3") //call function to generate sound
             alertView.backgroundColor = .red
             alertView.isHidden = false
             alertLabel1.text = "Game over!"
             alertLabel2.text = "You have scored:"
             alertLabel3.text = "\(scoreInt) points"
             resetGame()
         }
         else if (viewColor  == "green")
         {
             generateSound(fileName: "Winning_Bell.mp3")
             alertView.backgroundColor = .green
             alertView.isHidden = false
             alertLabel1.text = "Good Job"
             alertLabel2.text = "You have reached to"
             alertLabel3.text = "\(scoreInt) points"
             
         }
    
         Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) //Timer class with method to delay for 3 secs.
         {_ in
           self.alertView.isHidden = true
         }
     }
     
     func generateSound(fileName: String) -> Void
     {
         let path = Bundle.main.path(forResource: fileName, ofType:nil)! //create file path
            let fileUrl = URL(fileURLWithPath: path) //create file url from path
            do
            {
             sound = try AVAudioPlayer (contentsOf: fileUrl) //assign audio data from the given file path
            } catch
            {
                print("no such file found")
            }
           sound?.play() //play the audio file
     }
     
     func trailsCheck(trails : Int) -> Void
     {
         messageLabel.text = "Wrong guess!! You missed one trail..."
         if(trails == 1)
          {
              trailLabel3.isHidden = true
          }
          else if(trails == 2)
          {
              trailLabel2.isHidden = true
          }
          else if(trails == 3)
          {
              trailLabel1.isHidden = true
              generateAlert(viewColor: "red")
          }
     }
}
