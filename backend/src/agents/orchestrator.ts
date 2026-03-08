export interface AgentMessage {
    payload: any;
    action?: string;
    sender?: string;
    topic?: string;
    target?: string;
    priority?: number;
    metadata?: Record<string, any>;
    [key: string]: any;
}

export interface FeedLogEntry {
    id: string;
    projectId?: string;
    taskId?: string;
    agent: string;
    category: string;
    action: string;
    details: any;
    timestamp?: Date;
}

export class AgentOrchestrator {
    private agents: Map<string, any> = new Map();

    constructor(config?: any) {
        // Inicialização flexível para aceitar configs do index.ts
    }

    // Registrar um agente no sistema
    registerAgent(name: string, agent: any): void {
        this.agents.set(name, agent);
        console.log(`Agente ${name} registrado.`);
    }

    // Método exigido pelo src/index.ts
    async start(): Promise<void> {
        console.log("🚀 Orchestrator iniciado com sucesso.");
    }

    // Método para os agentes registrarem logs no feed central - Overloads
    logToFeed(log: FeedLogEntry): void;
    logToFeed(message: string, agentName?: string): void;
    logToFeed(messageOrLog: any, agentName?: string): void {
        const timestamp = new Date().toISOString();
        
        if (typeof messageOrLog === 'string') {
            // Forma simples - string com agente opcional
            const sender = agentName || 'System';
            console.log(`[${timestamp}] [${sender}]: ${messageOrLog}`);
        } else if (typeof messageOrLog === 'object' && messageOrLog !== null) {
            // Forma estruturada - objeto com log completo
            console.log(`[${timestamp}] Feed Log:`, JSON.stringify(messageOrLog, null, 2));
            // TODO: Inserir no banco de dados (feed_logs table)
        } else {
            console.log(`[${timestamp}] Invalid log entry type`);
        }
    }

    // Método para comunicação em massa - Overloads
    broadcast(message: AgentMessage, sender?: string): void;
    broadcast(action: string, payload?: any, sender?: string): void;
    broadcast(messageOrAction: any, payload?: any, sender?: string): void;
    broadcast(messageOrAction: any, payload?: any, sender?: string): void {
        const timestamp = new Date().toISOString();
        
        if (typeof messageOrAction === 'string') {
            // Forma simples - action string com payload opcional
            const action = messageOrAction;
            const senderId = sender || 'System';
            console.log(`[${timestamp}] 📢 Broadcast "${action}" de ${senderId}`);
            if (payload) {
                console.log(`  Payload: ${JSON.stringify(payload).substring(0, 100)}...`);
            }
        } else if (typeof messageOrAction === 'object' && messageOrAction !== null) {
            // Forma estruturada - AgentMessage
            const msg = messageOrAction;
            const senderId = sender || msg.sender || 'System';
            console.log(`[${timestamp}] 📢 Broadcast "${msg.action || 'unknown'}" de ${senderId}`);
        }
    }

    // Método para envio direcionado - Overloads
    async routeMessage(message: AgentMessage): Promise<any>;
    async routeMessage(target: string, message: AgentMessage): Promise<any>;
    async routeMessage(targetOrMessage: any, message?: any): Promise<any> {
        // Lógica flexível: se receber 2 args é (destino, msg), se 1 é a msg com target interno
        const target = message ? targetOrMessage : targetOrMessage.target;
        const msg = message || targetOrMessage;
        console.log(`🎯 Roteando mensagem para: ${target}`);

        if (this.agents.has(target)) {
            const agent = this.agents.get(target);
            return await agent.handleMessage(msg);
        } else {
            throw new Error(`Agente ${target} não encontrado.`);
        }
    }

    // Validação básica de mensagens
    validateMessage(message: AgentMessage): boolean {
        return !!(message && message.payload !== undefined);
    }

    // Processamento genérico
    processMessage(message: AgentMessage): void {
        if (!this.validateMessage(message)) {
            throw new Error('Mensagem inválida: payload ausente.');
        }
        console.log(`Processing: ${message.action}`);
    }
}
