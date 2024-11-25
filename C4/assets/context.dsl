workspace "ClearView" "is a supplemental **HR platform** that anonymizes candidate infomration while hightlighting objective skills and qualifying experience to reduce bias in the hiring process." {


    model {
        candidate = person "Candidate"
        employer = person "Employer"
        admin = person "Administrator"
        
        
        hrSystem = softwareSystem "HR System" " " "External"
        aiSystem = softwareSystem "AI System" " " "External"
        clearview = softwareSystem "Clearview" {
            web = container "Web Application" "Frontend" "Typescript & React" "Web Browser"
            candidateMgt = container "Candidate Manager" "Backend" "Java & Spring boot"
            hiringMgt = container "Hiring Manager" "Backend" "Java & Spring boot"
            resumeTracker = container "Resume Tracker" "Backend" "Java & Spring boot"
            surveyCollector = container "Survey Collector" "Backend" "Java & Spring boot"
            resumePayout = container "Resume Payout" "Backend" "Java & Spring boot"
            resumeMatcher = container "Resume AI Matcher" "Backend" "Python & Langchain"
            resumeTipsAnonymizer = container "Resume AI tips generator & anonymizer" "Backend" "Python & Langchain"
            db = container "Database Schema" "" "Postgres Database Schema" "Database"
            vectorDB = container "Vector Database Schema" "" "Vector Database Schema" "VDatabase"
            
            candidate -> web "Register\nUpload resume\nSubmit resume\nView matches\nRemove resume"
            web -> candidateMgt "Register using" "REST/HTTPS"
            web -> resumeTracker "Upload resume\nSubmit resume\Remove resume\nusing" "REST/HTTPS"
            resumeTracker -> resumeTipsAnonymizer "Generate tips using" "via: Topic: ResumeUpdated" "MQ"
            resumeTracker -> resumeTipsAnonymizer "Anonymize resume using" "via: Topic: ResumeSubmitted" "MQ"
            
            resumeTipsAnonymizer -> resumeMatcher "Avail resume for matching using" "via: Topic: ResumeAnonymized" "MQ" 
            
            employer -> web "Register\nCRUD job\nView matches\nUnlock resume\nHire candidate\nPass candidate"
            web ->  hiringMgt "Register\nCreate company profile\nCreate Job\nHire candidate\Skip candidate using" "REST/HTTPS"
            hiringMgt -> resumeMatcher "Create job using" "via: Topic: JobCreated" "MQ"
            hiringMgt -> resumePayout "Pay for unlocked resume using" "via: Topic:ResumeUnlocked" "MQ"
            hiringMgt -> surveyCollector "Complete survey using" "via: Topic:CandidateHired/skipped" "MQ"
            
            resumeMatcher -> aiSystem "Query AI model using" "REST/HTTPS"
            resumeTipsAnonymizer -> aiSystem "Embed resume using" "REST/HTTPS"
            resumeMatcher -> vectorDB "Reads from and writes to" "TCP"
            resumeTipsAnonymizer -> vectorDB "Reads from and writes to" "TCP"
            
            
            candidateMgt -> db "Reads from and writes to" "SQL/TCP"
            hiringMgt    -> db "Reads from and writes to" "SQL/TCP"
            resumeTracker -> db "Reads from and writes to" "SQL/TCP"
            surveyCollector -> db "Reads from and writes to" "SQL/TCP"
            resumePayout -> db "Reads from and writes to" "SQL/TCP"
            
            
        }
        

        admin -> clearview "Maintain users\nGenerate/view analytics\nGenerate/view reports"
        clearview -> hrSystem "Unlocked full resume"
    }

    views {
        systemContext clearview "Diagram1" {
            include *
            autolayout lr
        }

        container clearview "Diagram2" {
            include *
            autolayout lr
        }

        styles {
            element "Element" {
                color #ffffff
                background #0074b7
            }
            element "Person" {
                shape person
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "External"{
                background #999999
                color #ffffff
            }
            element "Database" {
                shape Cylinder
            }
            element "VDatabase" {
                shape Cylinder
                background #199b65
            }
            element "Cache" {
                shape Cylinder
                background #FF0000
            }
            element "Message Bus" {
                shape Pipe
            }
            element "MQ"{
                border dotted
                color #0074b7
            }
        }
    }

    configuration {
        scope softwaresystem
    }

}