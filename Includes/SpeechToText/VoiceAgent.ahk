Class VoiceAgent
{
    static m_Voice
    static m_Voices
    static m_VoiceIndex
    static m_VoiceEnabled
    Init()
    {
        Try {
            this.m_VoiceEnabled := gSAPIVoiceEnabled
            Debug.WriteStackPushPop("VoiceAgent.Init()", Debug.ErrLevelCore)
            VoiceAgent.m_Voice := New_SpVoice()
            VoiceAgent.m_Voices := VoiceAgent.m_Voice.GetVoices()
            VoiceAgent.m_VoiceIndex := 0
            ;VoiceAgent.m_Voice.Speak("Hello, World!", SpeechVoiceSpeakFlags.SVSFDefault)
            this.SetVoiceIndex(gSAPIVoiceIndex)
            this.SetSpeakRate(gSAPIVoiceRate)
            this.SetSpeakVolume(gSAPIVoiceVolume)
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.Init() Failed", Debug.ErrLevelCoreErrors)
        }
    }
    GetVoice()
    {
        Try {
            Debug.WriteStackPushPop("VoiceAgent.GetVoice()", Debug.ErrLevelCore)
            return VoiceAgent.m_Voice
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.GetVoicesDescriptions() Failed", Debug.ErrLevelCoreErrors)
        }
        return 0
    }
    GetVoices()
    {
        Try {
            Debug.WriteStackPushPop("VoiceAgent.GetVoices()", Debug.ErrLevelCore)
            return VoiceAgent.m_Voices
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.GetVoicesDescriptions() Failed", Debug.ErrLevelCoreErrors)
        }
        return 0
    }
    GetVoicesDescriptions()
    {
        
        Debug.WriteStackPushPop("VoiceAgent.GetVoicesDescriptions()", Debug.ErrLevelCore)
        ;VoiceAgent.m_Voice.Speak("GetVoicesDescriptions", SpeechVoiceSpeakFlags.SVSFDefault)
        descs := []
        Try {
            ct := VoiceAgent.m_Voices.Count()
            at:=0
            loop, %ct%
            {
                aVoice := VoiceAgent.m_Voices.Item(at)
                descs.push(aVoice.GetDescription())
                ;VoiceAgent.m_Voice.Speak(aVoice.GetDescription(), SpeechVoiceSpeakFlags.SVSFDefault)
                at++
            }
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.GetVoicesDescriptions() Failed", Debug.ErrLevelCoreErrors)
        }
        return descs
    }
    GetVoicesCount()
    {
        Debug.WriteStackPushPop("VoiceAgent.GetVoicesCount()", Debug.ErrLevelCore)
        try
        {
            return VoiceAgent.m_Voices.Count()
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.GetVoicesCount() Failed", Debug.ErrLevelCoreErrors)
        }
        return 0
    }
    SetVoiceIndex(Index)
    {
        
        Debug.WriteStackPushPop("VoiceAgent.SetVoiceIndex() " . Index, Debug.ErrLevelCore)
        Try {
            vIndex := clamp(Index,0,VoiceAgent.m_Voices.Count())
            VoiceAgent.m_VoiceIndex := vIndex
            VoiceAgent.m_Voice.Voice := VoiceAgent.m_Voices.Item(vIndex)
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.SetVoiceIndex() Failed", Debug.ErrLevelCoreErrors)
        }
    }
    GetVoiceIndex()
    {
        Debug.WriteStackPushPop("VoiceAgent.GetVoiceIndex() ", Debug.ErrLevelCore)
        Try{
            return VoiceAgent.m_VoiceIndex
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.GetVoiceIndex() Failed", Debug.ErrLevelCoreErrors)
        }
        return 0
    }
    SetSpeakRate(Rate)
    {
        vRate:=clamp(Rate,-10,10)
        Debug.WriteStackPushPop("VoiceAgent.SetSpeakRate() " . Rate, Debug.ErrLevelCore)
        Try {
            VoiceAgent.m_Voice.Rate := vRate
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.SetSpeakRate() Failed", Debug.ErrLevelCoreErrors)
        }
    }
    GetSpeakRate()
    {
        Debug.WriteStackPushPop("VoiceAgent.GetSpeakRate()", Debug.ErrLevelCore)
        return VoiceAgent.m_Voice.Rate
    }
    SetSpeakVolume(Volume)
    {
        vRate:=clamp(Volume,0,100)
        Debug.WriteStackPushPop("VoiceAgent.SetSpeakVolume() " . Volume, Debug.ErrLevelCore)
        Try {
            VoiceAgent.m_Voice.Volume := Volume
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.SetSpeakVolume() Failed", Debug.ErrLevelCoreErrors)
        }
    }
    GetSpeakVolume()
    {
        Debug.WriteStackPushPop("VoiceAgent.GetSpeakVolume()", Debug.ErrLevelCore)
        return VoiceAgent.m_Voice.Volume
    }
    Stop()
    {
        Debug.WriteStackPushPop("VoiceAgent.Stop()", Debug.ErrLevelCore)
        Try {
            VoiceAgent.m_Voice.Speak("" ,SpeechVoiceSpeakFlags.SVSFPurgeBeforeSpeak)
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.Stop() Failed", Debug.ErrLevelCoreErrors)
        }
    }
    Say(Text)
    {
        Debug.WriteStackPushPop("VoiceAgent.Say()", Debug.ErrLevelCore)
        if(!this.m_VoiceEnabled)
        {
            return
        }
        Try {
            VoiceAgent.m_Voice.Speak(text ,SpeechVoiceSpeakFlags.SVSFlagsAsync)
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.Say() Failed", Debug.ErrLevelCoreErrors)
        }
    }
    SayWait(Text)
    {
        Debug.WriteStackPushPop("VoiceAgent.SayWait()", Debug.ErrLevelCore)
        if(!this.m_VoiceEnabled)
        {
            return
        }
        Try {
            VoiceAgent.m_Voice.Speak(text ,SpeechVoiceSpeakFlags.SVSFDefault)
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.SayWait() Failed", Debug.ErrLevelCoreErrors)
        }
    }
    SayXML(XMLText)
    {
        Debug.WriteStackPushPop("VoiceAgent.SayXML()", Debug.ErrLevelCore)
        if(!this.m_VoiceEnabled)
        {
            return
        }
        Try {
            VoiceAgent.m_Voice.Speak(XMLText ,SpeechVoiceSpeakFlags.SVSFlagsAsync + SpeechVoiceSpeakFlags.SVSFIsXML)
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.SayXML() Failed", Debug.ErrLevelCoreErrors)
        }
    }
    SayXMLWait(XMLText)
    {
        Debug.WriteStackPushPop("VoiceAgent.SayXMLWait()", Debug.ErrLevelCore)
        if(!this.m_VoiceEnabled)
        {
            return
        }
        Try {
            VoiceAgent.m_Voice.Speak(XMLText ,SpeechVoiceSpeakFlags.SVSFDefault + SpeechVoiceSpeakFlags.SVSFIsXML)
        }
        Catch
        {
            Debug.WriteStackPushPop("VoiceAgent.SayXMLWait() Failed", Debug.ErrLevelCoreErrors)
        }
    }
}