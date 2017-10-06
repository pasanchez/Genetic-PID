classdef Pid_Agent < handle
    
    properties
        genome = rand(3,1).*5;
        score = 0;
        tf;
        sys;
        info;
    end
 
    methods
        
        function agent = Pid_Agent(tf)
            agent.tf = tf;
        end
        
        function new_agent = mate(this,other)

            new_agent = Pid_Agent(this.tf);
            new_agent.genome = this.genome + other.genome;
            new_agent.genome = new_agent.genome ./ 2;
            for i=1:3
                if rand() < 0.01
                    exp = (-1) ^ round(rand() *5);
                    new_agent.genome(i) = new_agent.genome(i) + exp * rand() * new_agent.genome(i);
                end
            end
        end
        
        function score = getScore(this)
            pid_ = pid(this.genome(1),this.genome(2),this.genome(3));
            this.sys = feedback(pid_*this.tf,1);
%             step(this.sys);
%             pause;
            this.info = stepinfo(this.sys);
            this.score = (1 / (1 + this.info.SettlingTime*10 + this.info.Overshoot) ^ 2)*1000;
%             fprintf('%d\n',this.score);
            score = this.score;
        end
    end
end