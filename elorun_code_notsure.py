#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np

def eloProb(eloA, eloB):
    return 1 / (1 + np.exp(np.log(10.0) * (eloB - eloA) / 400.0))

def eloUpdate(prob, winsA, k):
    return k * (winsA - prob)

def eloRegress(eloA, to, by, idx):
    for i in range(len(eloA)):
        if idx[i]:
            eloA[i] = eloA[i] + by * (to[i] - eloA[i])
    return eloA

def eloRun(teamA, teamB, weightsA, weightsB, winsA, k, adjTeamA, adjTeamB, regress, to, by, regressUnused, group, initialElos, flag):
    nTeams = len(initialElos)
    ncolA = teamA.shape[1]
    ncolB = teamB.shape[1]
    nBoth = ncolA + ncolB
    nGames = len(winsA)
    nRegress = np.sum(regress)

    currElo = np.array(initialElos, dtype=float)
    usedYet = np.zeros(nTeams, dtype=bool)
    groupElo = np.array(initialElos, dtype=float)

    out = np.zeros((nGames, 4 + 2 * nBoth), dtype=float)
    regOut = np.zeros((nRegress, nTeams), dtype=float)

    regRow = 0
    for i in range(nGames):
        e1 = np.zeros(ncolA, dtype=float)
        e2 = np.zeros(ncolB, dtype=float)
        curr1 = np.zeros(ncolA, dtype=float)
        curr2 = np.zeros(ncolB, dtype=float)

        # get initial Elos for team A
        for j in range(ncolA):
            tmA = int(teamA[i, j])
            e1[j] = groupElo[tmA]
            curr1[j] = currElo[tmA]
            usedYet[tmA] = True
            out[i, j] = tmA + 1

        # get initial Elos for team B
        for l in range(ncolB):
            if flag == 2:
                e2[l] = teamB[i, l]
                curr2[l] = teamB[i, l]
                out[i, ncolA + l] = 0
            else:
                tmB = int(teamB[i, l])
                e2[l] = groupElo[tmB]
                curr2[l] = currElo[tmB]
                usedYet[tmB] = True
                out[i, ncolA + l] = tmB + 1

        # calculate and store the update
        prb = eloProb(np.sum(e1) + adjTeamA[i], np.sum(e2) + adjTeamB[i])
        updt1 = eloUpdate(prb, winsA[i], k[i, 0])
        updt2 = eloUpdate(prb, winsA[i], k[i, 1]) * -1.0

        out[i, nBoth] = prb
        out[i, nBoth + 1] = winsA[i]
        out[i, nBoth + 2] = updt1
        out[i, nBoth + 3] = updt2

        # store new Elos for team A
        for j in range(ncolA):
            tmp = curr1[j] + updt1 * weightsA[j]
            out[i, nBoth + 4 + j] = tmp
            currElo[int(teamA[i, j])] = tmp

        # store new Elos for team B
        for l in range(ncolB):
            if flag == 2:
                out[i, nBoth + 4 + ncolA + l] = curr2[l]
            else:
                tmp = curr2[l] + updt2 * weightsB[l]
                out[i, nBoth + 4 + ncolA + l] = tmp
                currElo[int(teamB[i, l])] = tmp

        # This part is fine
        if regress[i]:
            currElo = eloRegress(currElo, to, by, usedYet)
            regOut[regRow, :] = currElo
            regRow += 1
            if not regressUnused:
                usedYet = np.zeros(nTeams, dtype=bool)

        if group[i]:
            groupElo = currElo

    return out, regOut

