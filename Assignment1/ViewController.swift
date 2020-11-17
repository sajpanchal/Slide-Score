//
//  ViewController.swift
//  Assignment1
//
//  Created by saj panchal on 2020-02-15.
//  Copyright © 2020 saj panchal. All rights reserved.
////

import UIKit
import AVFoundation //Framework for audio video operations
class ViewController: UIViewController {
    
    /* Variables */
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
    
    /* Outlets */
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
    
    /* Slider action function */
    @IBAction func slideIt(_ sender: Any)
    {
    }
    /* Outlets */
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tryButtonOutlet: UIButton!
    @IBOutlet weak var resetButtonOutlet: UIButton!
    @IBOutlet weak var checkButtonOutlet: UIButton!
    
    override func viewDidLoad()
       {
           super.viewDidLoad()
           resetGame()
           // Do any additional setup after loading the view.
       }
    
    /* Try button action fuction */
    @IBAction func tryButton(_ sender   : Any)
    {
        if(tryButtonOutlet.tag != 1) // check if the trybutton is not pressed for one or more time
        {
        randomInt = Int.random(in: 0...100)  // random function to generate random number from 0 to 100
        randomNumberLabel.text = String(randomInt)
        }
        else
        {
            messageLabel.text = "Please slide and press check now..."
        }
        tryButtonOutlet.tag = 1
    }
    
    /* Check button action function */
    @IBAction func checkButton(_ sender: Any)
    {
        if(trailsCountInt < 3 && tryButtonOutlet.tag == 1) // check if the try button is pressed and at least 1 trail is left.
        {
            tryButtonOutlet.tag = 0
            sliderInt = Int(slider.value)
            differenceInt = abs(randomInt - sliderInt) //absolute difference between and random number and slider value
            pointsCalc(diffInt: differenceInt) //function to calculate the points
            totalScoreLabel.text = String(scoreInt)
            milestoneDiff = abs((fiftyMilestone * 50) - scoreInt) //expression to detect every 50's milestone
            if(milestoneDiff >= 50) //check if the milestone is reached
            {
                generateAlert(viewColor: "green") //function to show up view with score
                fiftyMilestone += 1 //increase the multiplier
            }
        }
        else if (tryButtonOutlet.tag != 1)
        {
            messageLabel.text = "Please press try to play!"
        }
        else
        {
            generateAlert(viewColor: "red")
            scoreInt = 0
            fiftyMilestone = 0
            messageLabel.text = "Game over! Reset to start a new game."
        }
    }
    
    /* Reset button action function */
    @IBAction func resetButton(_ sender: Any)
    {
        resetGame()
    }
    
    /* Info button action function */
    @IBAction func infoButton(_ sender: Any)
    {
    }
/*--------------------------------------Functions--------------------------------------------*/
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
         switch diffInt
         {
         case 0,1:  //if the difference is -1+
             generateSound(fileName: "win-win.mp3")
             scoreInt += 5
             messageLabel.text = "+5 points!"
             messageLabel.textColor = .green
             slider.value = 0  //move the slider to 0 position
         case 2,3: //if the difference is -3+
             generateSound(fileName: "win-win.mp3")
             scoreInt += 4
             messageLabel.text = "+4 points!"
             messageLabel.textColor = .green
             slider.value = 0
         case 4,5: //if the difference is -5+
             generateSound(fileName: "win-win.mp3")
             scoreInt += 3
             messageLabel.text = "+3 points!"
             messageLabel.textColor = .green
             slider.value = 0
         case 6...10: //if the difference is -10+
            generateSound(fileName: "win-win.mp3")
             scoreInt += 1
             messageLabel.text = "+1 points!"
             messageLabel.textColor = .green
             slider.value = 0
         case 11...100: //if the difference is -100+
             generateSound(fileName: "beep.mp3")
             trailsCountInt += 1
             scoreInt += 0
             slider.value = 0
             trailsCheck(trails: trailsCountInt) //function to deduct the trails
         default:
             generateSound(fileName: "beep.mp3")
             messageLabel.text = "Please slide and Press Try..."
             messageLabel.textColor = .red
             slider.value = 0
         }
     }
     /* Function to Show up the sub view */
     func generateAlert(viewColor : String) -> Void
     {
         if(viewColor == "red")
         {
             generateSound(fileName: "Game-over-robotic-voice.mp3")  //function to play audio file
             alertView.backgroundColor = .red //show the view
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
    
         Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) //timer class with method to generate 3 sec delay
         {_ in
           self.alertView.isHidden = true
         }
     }
     /* Function to create sound on event trigger */
     func generateSound(fileName: String) -> Void
     {
         let path = Bundle.main.path(forResource: fileName, ofType:nil)! // audio file path
            let fileUrl = URL(fileURLWithPath: path) //create URL from file path
            do //check if the path is valid
            {
                sound = try AVAudioPlayer (contentsOf: fileUrl)  // extracts audio data from the fileurl
            } catch
            {
                print("no such file found")
            }
           sound?.play() //plays audio file
     }
     
     /* function to condition trails */
     func trailsCheck(trails : Int) -> Void
     {
         messageLabel.text = "Wrong guess!! You missed one trial!"
        messageLabel.textColor = .red
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

