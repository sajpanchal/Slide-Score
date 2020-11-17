//
//  NormalViewController.swift
//  Assignment1
//
//  Created by saj panchal on 2020-02-17.
//  Copyright © 2020 saj panchal. All rights reserved.
//

import UIKit
import AVFoundation   //Framework for Audio video files
class NormalViewController: UIViewController {

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
        @IBOutlet weak var messageLabel: UILabel!
        @IBOutlet weak var tryButtonOutlet: UIButton!
        @IBOutlet weak var resetButtonOutlet: UIButton!
        @IBOutlet weak var checkButtonOutlet: UIButton!
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
         resetGame()
    }
    
        @IBAction func slideIt(_ sender: Any)
        {
        }
        
        @IBAction func tryButton(_ sender   : Any)
        {
            if(tryButtonOutlet.tag != 1)
            {
            randomInt = Int.random(in: 0...200) //random number from 0 to 200
            randomNumberLabel.text = String(randomInt)
            }
            else
            {
                messageLabel.text = "Please slide and press check!!"
            }
            tryButtonOutlet.tag = 1  //tag is 1 if try button is pressed
        }
        
        @IBAction func checkButton(_ sender: Any)
        {
            if(trailsCountInt < 3 && tryButtonOutlet.tag == 1) // check if try button is pressed and there is atleast 1 trail left
            {
                tryButtonOutlet.tag = 0
                sliderInt = Int(slider.value)
                differenceInt = abs(randomInt - sliderInt) // absolute difference between slider and random value
                pointsCalc(diffInt: differenceInt)  // function call for points calculation
                totalScoreLabel.text = String(scoreInt)
                milestoneDiff = abs((fiftyMilestone * 50) - scoreInt) //expression to detect every 50's milestone
                if(milestoneDiff >= 50) //if 50 milestone crossed
                {
                    generateAlert(viewColor: "green") //show up view with score and message
                    fiftyMilestone += 1
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
        
        @IBAction func resetButton(_ sender: Any)
        {
            resetGame()
        }
        
        @IBAction func infoButton(_ sender: Any)
        {
        }
/*----------------------------------------------------Functions----------------------------------------------------*/
    /* Function to reset the game */
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
            //alertView.isHidden = true
        }
    
        /* Function for calculating the points based on differences */
        func pointsCalc(diffInt: Int) -> Void
        {
            switch diffInt {
            case 0,1: //if the guess is +-1
                generateSound(fileName: "win-win.mp3") //function to play audio file
                scoreInt += 5 // accumulate the total score
                messageLabel.text = "+5 points!"
                slider.value = 0 // move slider to 0 position
            case 2,3: //if the guess is +-3
                generateSound(fileName: "win-win.mp3")
                scoreInt += 4
                messageLabel.text = "+4 points!"
                slider.value = 0
            case 4,5: //if the guess is +-5
                generateSound(fileName: "win-win.mp3")
                scoreInt += 3
                messageLabel.text = "+3 points!"
                slider.value = 0
            case 6...10: //if the guess is +-10
               generateSound(fileName: "win-win.mp3")
                scoreInt += 1
                messageLabel.text = "+1 points!"
                slider.value = 0
            case 11...200: //if the guess is +-200
                generateSound(fileName: "beep.mp3")
                trailsCountInt += 1
                scoreInt += 0
                slider.value = 0
                trailsCheck(trails: trailsCountInt) //function to deduct trials and count it.
            default:
                generateSound(fileName: "beep.mp3")
                messageLabel.text = "Please slide and Press Try!"
                slider.value = 0
            }
        }
    
        func generateAlert(viewColor : String) -> Void
        {
            if(viewColor == "red")
            {
                generateSound(fileName: "Game-over-robotic-voice.mp3")
                alertView.backgroundColor = .red  //set background color of view
                alertView.isHidden = false  //show the view
                alertLabel1.text = "Game over!"
                alertLabel2.text = "You have scored:"
                alertLabel3.text = "\(scoreInt) points"  //display score
                resetGame() //reset the game
            }
            else if (viewColor  == "green")
            {
                generateSound(fileName: "Winning_Bell.mp3")
                alertView.backgroundColor = .green
                alertView.isHidden = false
                alertLabel1.text = "Good Job!!"
                alertLabel2.text = "Your score is:"
                alertLabel3.text = "\(scoreInt) points"
            }
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) // time delay of 3 secs with no repeatation.
            {_ in
              self.alertView.isHidden = true
            }
        }
        
        func generateSound(fileName: String) -> Void
        {
               let path = Bundle.main.path(forResource: fileName, ofType:nil)!  //define the audio file path
               let fileUrl = URL(fileURLWithPath: path) // generate URL from path
               do // check if the file is present
               {
                sound = try AVAudioPlayer (contentsOf: fileUrl) // class to that provides playback of audio data from a specified file
               } catch
               {
                   print("no such file found")
               }
              sound?.play() // play audio file
        }
        
        func trailsCheck(trails : Int) -> Void
        {
            messageLabel.text = "Wrong guess!! You lost one trail."
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
                 generateAlert(viewColor: "red") // pop up the subview with message
             }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


